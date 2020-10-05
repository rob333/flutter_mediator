import 'package:flutter/widgets.dart';

import 'mediator_publisher.dart';

@immutable
class Host<MyModel extends Publisher> extends StatefulWidget {
  const Host({
    Key key,
    @required this.model,
    @required this.child,
  })  : assert(model != null),
        assert(child != null),
        super(key: key);

  final MyModel model;
  final Widget child;

  static InheritModelOfMediator<MyModel> of<MyModel extends Publisher>(
    BuildContext context, {
    Iterable<Object> aspects,
    bool listen = true,
  }) {
    assert(listen || aspects == null,
        "Don't provide aspects if you're not going to listen to them.");

    if (!listen) {
      final inheritModel = context
          .findAncestorWidgetOfExactType<InheritModelOfMediator<MyModel>>();
      assert(inheritModel != null,
          'Could not find an ancestor of MediatorInheritModel<$MyModel>');
      return inheritModel;
    }

    if (aspects == null || aspects.isEmpty) {
      final inheritModel =
          InheritedModel.inheritFrom<InheritModelOfMediator<MyModel>>(context);
      assert(inheritModel != null,
          'Could not find an ancestor of MediatorInheritModel<$MyModel>');
      return inheritModel;
    }

    InheritModelOfMediator<MyModel> inheritModel;
    for (final aspect in aspects) {
      inheritModel =
          InheritedModel.inheritFrom<InheritModelOfMediator<MyModel>>(context,
              aspect: aspect);
      assert(inheritModel != null,
          'Could not find an ancestor of MediatorInheritModel<$MyModel>');
    }
    // inheritModel.state.addRegAspects(aspects);
    return inheritModel;
  }

  /// register method, which is `listen = true`
  static InheritModelOfMediator<MyModel> register<MyModel extends Publisher>(
    BuildContext context, {
    Iterable<Object> aspects,
  }) {
    if (aspects == null || aspects.isEmpty) {
      final inheritModel =
          InheritedModel.inheritFrom<InheritModelOfMediator<MyModel>>(context);
      assert(inheritModel != null,
          'Could not find an ancestor of MediatorInheritModel<$MyModel>');
      return inheritModel;
    }

    InheritModelOfMediator<MyModel> inheritModel;
    for (final aspect in aspects) {
      inheritModel =
          InheritedModel.inheritFrom<InheritModelOfMediator<MyModel>>(context,
              aspect: aspect);
      assert(inheritModel != null,
          'Could not find an ancestor of MediatorInheritModel<$MyModel>');
    }
    // inheritModel.state.addRegAspects(aspects);
    return inheritModel;
  }

  /// getInherit method, which is `listen = false`
  static InheritModelOfMediator<MyModel> getInherit<MyModel extends Publisher>(
      BuildContext context) {
    final inheritModel = context
        .findAncestorWidgetOfExactType<InheritModelOfMediator<MyModel>>();
    assert(inheritModel != null,
        'Could not find an ancestor of MediatorInheritModel<$MyModel>');
    return inheritModel;
  }

  /// getInheritOfModel method, which is `listen = false`, and return the model
  static MyModel getInheritOfModel<MyModel extends Publisher>(
      BuildContext context) {
    final inheritModel = context
        .findAncestorWidgetOfExactType<InheritModelOfMediator<MyModel>>();
    assert(inheritModel != null,
        'Could not find an ancestor of MediatorInheritModel<$MyModel>');
    return inheritModel.state.widget.model;
  }

  @override
  _HostState createState() => _HostState<MyModel>();
}

class _HostState<MyModel extends Publisher> extends State<Host<MyModel>> {
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
    return InheritModelOfMediator<MyModel>(
      state: this,
      child: widget.child,
    );
  }
}

/// The [InheritedModel] subclass that is rebuilt by [_HostState]
@immutable
class InheritModelOfMediator<MyModel extends Publisher> extends InheritedModel {
  const InheritModelOfMediator({
    Key key,
    @required _HostState<MyModel> state,
    @required Widget child,
  })  : _state = state,
        super(key: key, child: child);

  final _HostState<MyModel> _state;

  _HostState<MyModel> get state => _state;
  // Observer get model => _state.widget.model;

  @override
  bool updateShouldNotify(InheritModelOfMediator<MyModel> oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
      InheritModelOfMediator<MyModel> oldWidget, Set<Object> dependencies) {
    return dependencies.intersection(_state._frameAspects).isNotEmpty;
  }
}
