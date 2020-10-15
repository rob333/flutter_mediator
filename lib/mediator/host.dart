import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'assert.dart';
import 'pub.dart';
import 'rx/rx_impl.dart';

class Host<TModel extends Pub> extends StatefulWidget {
  const Host({
    Key key,
    @required TModel model,
    /*@required*/ this.child,
  })  : assert(model != null),
        // assert(child != null),
        _model = model,
        super(key: key);

  final TModel _model;
  final Widget child;

  //* For MultiHost.create, to accmulate the child
  static List<Widget> stateChildColl;

  //* register method, which is [listen = true], and add aspects to the [regAspects]
  //* return the [TModel]
  static TModel register<TModel extends Pub>(
    BuildContext context, {
    Iterable<Object> aspects,
  }) {
    assert(ifModelTypeCorrect(TModel, 'Host.register'));
    if (aspects == null || aspects.isEmpty) {
      final inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context);
      assert(ifInheritedModel<TModel>(inheritedModel));

      final state = inheritedModel._state;
      // aspects is null, no need to `addRegAspects`
      return state.widget._model;
    }

    InheritedModelOfMediator<TModel> inheritedModel;
    for (final aspect in aspects) {
      inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context,
              aspect: aspect);
      assert(ifInheritedModel<TModel>(inheritedModel));
    }

    final state = inheritedModel._state;
    return state.addRegAspects(aspects);
  }

  //* Reference section:
  //* Register the model, with [listen], [aspects] parameter
  static InheritedModelOfMediator<TModel> of<TModel extends Pub>(
    BuildContext context, {
    Iterable<Object> aspects,
    bool listen = true,
  }) {
    assert(ifModelTypeCorrect(TModel, 'Host.of'));
    assert(
        listen || aspects == null, 'Provide aspects only if listen == true.');

    //* listen == false
    if (!listen) {
      final inheritedModel = context
          .findAncestorWidgetOfExactType<InheritedModelOfMediator<TModel>>();
      assert(ifInheritedModel<TModel>(inheritedModel));
      return inheritedModel;
    }

    //* listen == true, aspect == null or isEmpty, i.e. like inheritedWidget
    if (aspects == null || aspects.isEmpty) {
      final inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context);
      assert(ifInheritedModel<TModel>(inheritedModel));
      return inheritedModel;
    }

    //* listen == true, aspect == isNotEmpty
    InheritedModelOfMediator<TModel> inheritedModel;
    for (final aspect in aspects) {
      inheritedModel =
          InheritedModel.inheritFrom<InheritedModelOfMediator<TModel>>(context,
              aspect: aspect);
      assert(ifInheritedModel<TModel>(inheritedModel));
    }
    inheritedModel._state.addRegAspects(aspects);
    return inheritedModel;
  }

  //* getInherited method, which is [listen = false], return the [InheritedModelOfMediator]
  static InheritedModelOfMediator<TModel> getInherited<TModel extends Pub>(
      BuildContext context) {
    assert(ifModelTypeCorrect(TModel, 'Host.getInherited'));
    final inheritedModel = context
        .findAncestorWidgetOfExactType<InheritedModelOfMediator<TModel>>();
    assert(ifInheritedModel<TModel>(inheritedModel));
    return inheritedModel;
  }

  /// Deprecated, use `Publish.getModel<Model>()` instead
  // //* getInheritedOfModel method, which is [listen = false], return the [TModel]
  // static TModel getInheritedOfModel<TModel extends Pub>(
  //     BuildContext context) {
  //   assert(assertModelType(TModel, 'Host.getInheritedOfModel'));
  //   final inheritedModel = context
  //       .findAncestorWidgetOfExactType<InheritedModelOfMediator<TModel>>();
  //   assert(assertInheritedModel<TModel>(inheritedModel));
  //   return inheritedModel.state.widget.model;
  // }

  //! end reference section

  @override
  _HostState createState() {
    var widget = child;
    if (child == null) {
      assert(stateChildColl.isNotEmpty,
          'Host.stateChildColl is empty, make sure to use MultiHost.create()');
      widget = stateChildColl.removeLast();
    }
    return _HostState<TModel>(widget);
  }
}

class _HostState<TModel extends Pub> extends State<Host<TModel>> {
  _HostState(this.child);
  final Widget child;

  final _regAspects = HashSet<Object>(); // all aspects that registered
  final _frameAspects = HashSet<Object>(); // aspects to be updated

  //* Add [aspects] to the registered aspects of the model
  TModel addRegAspects(Iterable<Object> aspects) {
    if (aspects != null) {
      _regAspects.addAll(aspects);
    }
    return widget._model;
  }

  //* When the aspects published, this state needs to setState to update the view.
  void _frameAspectListener([Object aspects]) {
    setState(() {
      /// Add aspect into [_frameAspects]
      final element = context as StatefulElement;
      if (!element.dirty) {
        /// The widget is in a new frame time,
        /// clear previous processed frame aspects.
        _frameAspects.clear();
      }

      if (aspects == null) {
        /// If aspect == null, then update all aspects.
        _frameAspects.addAll(_regAspects);
      } else if (aspects is Iterable) {
        _frameAspects.addAll(aspects);
      } else if (aspects is RxImpl) {
        _frameAspects.addAll(aspects.rxAspects);
      } else {
        _frameAspects.add(aspects);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget._model.setCallback(_frameAspectListener, _regAspects, _frameAspects);
  }

  @override
  void dispose() {
    widget._model.restoreCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedModelOfMediator<TModel>(
      state: this,
      frameAspect: _frameAspects,
      child: child,
    );
  }
}

/// The [InheritedModel] subclass that is rebuilt by [_HostState]
@immutable
class InheritedModelOfMediator<TModel extends Pub> extends InheritedModel {
  const InheritedModelOfMediator({
    Key key,
    @required _HostState<TModel> state,
    @required HashSet<Object> frameAspect,
    @required Widget child,
  })  : _state = state,
        _frameAspects = frameAspect,
        super(key: key, child: child);

  final _HostState<TModel> _state;
  final HashSet<Object> _frameAspects;

  // _HostState<TModel> get state => _state;
  // Pub get model => _state.widget.model;

  @override
  bool updateShouldNotify(InheritedModelOfMediator<TModel> oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
      InheritedModelOfMediator<TModel> oldWidget, Set<Object> dependencies) {
    return dependencies.intersection(_frameAspects).isNotEmpty;
  }
}
