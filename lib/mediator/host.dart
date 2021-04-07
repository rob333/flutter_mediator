import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'assert.dart';
import 'pub.dart';
import 'rx/rx_impl.dart';

/// Class `Host` handles the registration of widget aspects.
/// And dispatch aspects when updating.
@immutable
class Host<TModel extends Pub> extends StatefulWidget {
  const Host({
    Key? key,
    required TModel model,
    /*required*/ this.child,
  })  : // assert(child != null),
        _model = model,
        super(key: key);

  final TModel _model;
  final Widget? child;

  /// Map of the models section:
  /// Dependency injection of models, map of models
  static final stateModels = HashMap<Type, Pub>();

  /// static: Get the model.
  static Model model<Model extends Pub>() {
    assert(ifStateModel<Model>(stateModels[Model]));
    return stateModels[Model] as Model;
  }

  /// For MultiHost.create, to accmulate the child
  static List<Widget> stateChildColl = <Widget>[];

  /// Register method, which is [listen = true], and add aspects to the [regAspects]
  /// return the [TModel]
  static TModel register<TModel extends Pub>(
    BuildContext context, {
    Iterable<Object>? aspects,
  }) {
    assert(ifModelTypeCorrect(TModel, 'Host.register'));
    if (aspects == null || aspects.isEmpty) {
      final inheritedModel =
          InheritedMediator.inheritFrom<InheritedMediator<TModel>>(context);
      assert(ifInheritedModel<TModel>(inheritedModel));

      final model = inheritedModel!._model;
      // aspects is null, no need to `addRegAspects`
      return model;
    }

    final inheritedModel =
        InheritedMediator.inheritFrom<InheritedMediator<TModel>>(context,
            aspect: aspects);
    assert(ifInheritedModel<TModel>(inheritedModel));

    final model = inheritedModel!._model;

    /// Add [aspects] to the registered aspects of the model
    // if (aspects != null) {
    model.regAspects.addAll(aspects);
    // }
    return model;
  }

  @override
  _HostState createState() {
    var widget = child;
    if (child == null) {
      assert(stateChildColl.isNotEmpty,
          'Host.stateChildColl is empty, make sure to use MultiHost.create()');
      widget = stateChildColl.removeLast();
    }
    return _HostState<TModel>(widget!);
  }
}

class _HostState<TModel extends Pub> extends State<Host<TModel>> {
  _HostState(this.child);
  final Widget child;

  late HashSet<Object> _regAspects; // all aspects been registered
  late HashSet<Object> _frameAspects; // aspects to be updated

  /// When the aspects published, needs to setState to update the widget view.
  void _frameAspectListener([Object? aspects]) {
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
      } else if (aspects is Iterable<Object>) {
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

    final model = widget._model;
    model.setCallback(_frameAspectListener);
    _frameAspects = model.frameAspects;
    _regAspects = model.regAspects;
  }

  @override
  void dispose() {
    widget._model.restoreCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedMediator<TModel>(
      model: widget._model,
      frameAspect: _frameAspects,
      child: child,
    );
  }
}

/// The [InheritedModel] subclass that is rebuilt by [_HostState].
/// The type parameter `TModel` is the type of the model.
/// The aspect type is always  `Object`.
class InheritedMediator<TModel extends Pub> extends InheritedWidget {
  /// Creates an inherited widget that supports dependencies qualified by
  /// "aspects", i.e. a descendant widget can indicate that it should
  /// only be rebuilt if a specific aspect of the model changes.
  const InheritedMediator({
    Key? key,
    // required _HostState<TModel> state,
    required TModel model,
    required HashSet<Object> frameAspect,
    required Widget child,
  })   : //_state = state,
        _model = model,
        _frameAspects = frameAspect,
        super(key: key, child: child);

  // final _HostState<TModel> _state;
  final TModel _model;
  final HashSet<Object> _frameAspects;

  // _HostState<TModel> get state => _state;
  // Pub get model => _state.widget.model;

  @override
  InheritedMediatorElement<TModel> createElement() =>
      InheritedMediatorElement<TModel>(this);

  @override
  bool updateShouldNotify(InheritedMediator<TModel> oldWidget) {
    return true;
  }

  /// Return true if the changes between this model and [oldWidget] match any
  /// of the [dependencies].
  @protected
  bool updateShouldNotifyDependent(
      InheritedMediator<TModel> oldWidget, HashSet<Object> dependencies) {
    return dependencies.intersection(_frameAspects).isNotEmpty;
  }

  /*
   *
   * clone frome inherited_model.dart
   * 
  */
  // @protected
  // bool isSupportedAspect(Object aspect) => true;

  // The [result] will be a list of all of context's type T ancestors concluding
  // with the one that supports the specified model [aspect].
  static void _findModels<T extends InheritedMediator>(
      BuildContext context, Object aspect, List<InheritedElement> results) {
    final InheritedElement? model =
        context.getElementForInheritedWidgetOfExactType<T>();
    if (model == null) return;

    results.add(model);

    assert(model.widget is T);
    // final T modelWidget = model.widget as T;
    // if (modelWidget.isSupportedAspect(aspect)) return; // always true
    return;

    /* never got here
    Element modelParent;
    model.visitAncestorElements((Element ancestor) {
      modelParent = ancestor;
      return false;
    });
    if (modelParent == null) return;

    _findModels<T>(modelParent, aspect, results);
    */
  }

  /// Makes [context] dependent on the specified [aspect] of an [InheritedModel]
  /// of type T.
  ///
  /// When the given [aspect] of the model changes, the [context] will be
  /// rebuilt. The [updateShouldNotifyDependent] method must determine if a
  /// change in the model widget corresponds to an [aspect] value.
  ///
  /// The dependencies created by this method target all [InheritedModel] ancestors
  /// of type T up to and including the first one.
  ///
  /// If [aspect] is null this method is the same as
  /// `context.dependOnInheritedWidgetOfExactType<T>()`.
  ///
  /// If no ancestor of type T exists, null is returned.
  static T? inheritFrom<T extends InheritedMediator>(BuildContext context,
      {Iterable<Object>? aspect}) {
    if (aspect == null) return context.dependOnInheritedWidgetOfExactType<T>();

    // Create a dependency on all of the type T ancestor models up until
    // a model is found.
    final models = <InheritedElement>[];
    _findModels<T>(context, aspect, models);
    if (models.isEmpty) {
      return null;
    }

    final InheritedElement lastModel = models.last;
    for (final InheritedElement model in models) {
      final value =
          context.dependOnInheritedElement(model, aspect: aspect) as T;
      if (model == lastModel) return value;
    }

    assert(false);
    return null;
  }
}

/// An [Element] that uses a [InheritedMediator] as its configuration.
/// The type parameter `TModel` is the model type.
/// Aspect type is always `Object`.
class InheritedMediatorElement<TModel extends Pub> extends InheritedElement {
  /// Creates an element that uses the given widget as its configuration.
  InheritedMediatorElement(InheritedMediator<TModel> widget) : super(widget);

  @override
  InheritedMediator<TModel> get widget =>
      super.widget as InheritedMediator<TModel>;

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final HashSet<Object>? dependencies =
        getDependencies(dependent) as HashSet<Object>?;
    if (dependencies != null && dependencies.isEmpty) return;

    if (aspect == null) {
      setDependencies(dependent, HashSet<Object>());
    } else {
      /// Modified: `add` to `addAll`
      // assert(aspect is Object);
      // setDependencies(dependent,
      //     (dependencies ?? HashSet<Object>())..add(aspect as Object));

      assert(
          aspect is Iterable<Object>, 'Aspect to inherit should be Iterable.');
      setDependencies(
          dependent,
          (dependencies ?? HashSet<Object>())
            ..addAll(aspect as Iterable<Object>));
    }
  }

  @override
  void notifyDependent(InheritedMediator<TModel> oldWidget, Element dependent) {
    final HashSet<Object>? dependencies =
        getDependencies(dependent) as HashSet<Object>?;
    if (dependencies == null) return;
    if (dependencies.isEmpty ||
        widget.updateShouldNotifyDependent(oldWidget, dependencies))
      dependent.didChangeDependencies();
  }
}
