import 'package:flutter/widgets.dart';

import 'mediator_publisher.dart';

@immutable
class Host<TModel extends Publisher> extends StatefulWidget {
  const Host({
    Key key,
    @required this.model,
    @required this.child,
  })  : assert(model != null),
        assert(child != null),
        super(key: key);

  final TModel model;
  final Widget child;

  static InheritedModelOfMediator<TModel> of<TModel extends Publisher>(
    BuildContext context, {
    Iterable<Object> aspects,
    bool listen = true,
  }) {
    assert(
        listen || aspects == null, 'Provide aspects only if listen == true.');

    if (!listen) {
      final inheritedModel = context
          .findAncestorWidgetOfExactType<InheritedModelOfMediator<TModel>>();
      assert(inheritedModel != null,
          'Could not find an ancestor of InheritedModelOfMediator<$TModel>');
      return inheritedModel;
    }

    if (aspects == null || aspects.isEmpty) {
      final inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context);
      assert(inheritedModel != null,
          'Could not find an ancestor of InheritedModelOfMediator<$TModel>');
      return inheritedModel;
    }

    InheritedModelOfMediator<TModel> inheritedModel;
    for (final aspect in aspects) {
      inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context,
              aspect: aspect);
      assert(inheritedModel != null,
          'Could not find an ancestor of InheritedModelOfMediator<$TModel>');
    }
    // inheritedModel.state.addRegAspects(aspects);
    return inheritedModel;
  }

  /// register method, which is `listen = true`
  static InheritedModelOfMediator<TModel> register<TModel extends Publisher>(
    BuildContext context, {
    Iterable<Object> aspects,
  }) {
    if (aspects == null || aspects.isEmpty) {
      final inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context);
      assert(inheritedModel != null,
          'Could not find an ancestor of InheritedModelOfMediator<$TModel>');
      return inheritedModel;
    }

    InheritedModelOfMediator<TModel> inheritedModel;
    for (final aspect in aspects) {
      inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context,
              aspect: aspect);
      assert(inheritedModel != null,
          'Could not find an ancestor of InheritedModelOfMediator<$TModel>');
    }
    // inheritedModel.state.addRegAspects(aspects);
    return inheritedModel;
  }

  /// getInherit method, which is `listen = false`
  static InheritedModelOfMediator<TModel> getInherit<TModel extends Publisher>(
      BuildContext context) {
    final inheritedModel = context
        .findAncestorWidgetOfExactType<InheritedModelOfMediator<TModel>>();
    assert(inheritedModel != null,
        'Could not find an ancestor of InheritedModelOfMediator<$TModel>');
    return inheritedModel;
  }

  /// getInheritOfModel method, which is `listen = false`, and return the model
  static TModel getInheritOfModel<TModel extends Publisher>(
      BuildContext context) {
    final inheritedModel = context
        .findAncestorWidgetOfExactType<InheritedModelOfMediator<TModel>>();
    assert(inheritedModel != null,
        'Could not find an ancestor of InheritedModelOfMediator<$TModel>');
    return inheritedModel.state.widget.model;
  }

  @override
  _HostState createState() => _HostState<TModel>();
}

class _HostState<TModel extends Publisher> extends State<Host<TModel>> {
  final Set<Object> _regAspects = {}; // all aspects that have been registered
  final Set<Object> _frameAspects = {}; // aspects to be updated

  Set<Object> get frameAspects => _frameAspects;

  void addRegAspects(Iterable<Object> aspects) {
    _regAspects.addAll(aspects);
  }

  //* when aspects of a widget notified, the widget needs to setState to update the view.
  void _frameAspectListener([Object aspects]) {
    setState(() {
      // add aspect into [_frameAspects]
      final element = context as StatefulElement;
      if (!element.dirty) {
        // widget is in a new frame time
        // clear previous processed frame aspects
        _frameAspects.clear();
      }

      if (aspects == null) {
        // if aspect == null, then update all aspects
        _frameAspects.addAll(_regAspects);
      } else if (aspects is Iterable) {
        _frameAspects.addAll(aspects);
      } else {
        _frameAspects.add(aspects);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.model.setCallback(_frameAspectListener, _frameAspects);
  }

  @override
  void dispose() {
    widget.model.restoreCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedModelOfMediator<TModel>(
      state: this,
      child: widget.child,
    );
  }
}

/// The [InheritedModel] subclass that is rebuilt by [_HostState]
@immutable
class InheritedModelOfMediator<TModel extends Publisher>
    extends InheritedModel {
  const InheritedModelOfMediator({
    Key key,
    @required _HostState<TModel> state,
    @required Widget child,
  })  : _state = state,
        super(key: key, child: child);

  final _HostState<TModel> _state;

  _HostState<TModel> get state => _state;
  // Observer get model => _state.widget.model;

  @override
  bool updateShouldNotify(InheritedModelOfMediator<TModel> oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
      InheritedModelOfMediator<TModel> oldWidget, Set<Object> dependencies) {
    return dependencies.intersection(_state._frameAspects).isNotEmpty;
  }
}
