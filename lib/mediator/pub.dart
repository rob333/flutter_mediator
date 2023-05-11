import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'assert.dart';
import 'controller.dart';
import 'host.dart';
import 'rx/rx_impl.dart';
import 'subscriber.dart';

/// A base class for Models
class Pub {
  Pub() : publish = dummyCallback {
    assert(() {
      if (Host.stateModels[runtimeType] != null) {
        throw FlutterError('Duplicate model type of <$runtimeType>');
      }
      return true;
    }());

    /// class initial steps
    /// 1. rx variables initial
    /// 2. model extends from Pub and initial
    /// 3. set the Pub of rx variables with this pub(model)
    RxImpl.setPub(this);

    // runtimeType == 'Pub' is the globalPub
    assert(() {
      if (runtimeType.toString() != 'Pub') {
        debugPrint('RxImpl set pub to: $this');
      }
      return true;
    }());

    Host.stateModels[runtimeType] = this;
    init();
  }

  @mustCallSuper
  @protected
  void init() {}

  /// static: Get the model.
  static Model getModel<Model extends Pub>() {
    assert(ifStateModel<Model>(Host.stateModels[Model]));
    debugPrint('Deprecated Pub.getModel<Model>(): Please use Host.model<>();');
    return Host.stateModels[Model] as Model;
  }

  /// static: Get the model, the same as getModel<Model>().
  static Model model<Model extends Pub>() {
    assert(ifStateModel<Model>(Host.stateModels[Model]));
    debugPrint('Deprecated Pub.model<Model>(): Please use Host.model<>();');
    return Host.stateModels[Model] as Model;
  }

  /// Used before `Host` init state for models.
  static void dummyCallback([Object? aspects]) {}

  /// The publish function, the setState function of the [Host] state.
  PublishFn publish;

  /// All aspects that has been registered to this [Pub].
  final _regAspects = HashSet<Object>();

  /// Aspects to be updated in this frame time of this [Pub].
  final _frameAspects = HashSet<Object>();

  /// Return all the aspects that has been registered to this [Pub].
  HashSet<Object> get regAspects => _regAspects;

  /// Return the updated aspects of this [Pub].
  HashSet<Object> get frameAspects => _frameAspects;

  /// Set callback and aspects information of the model.
  void setCallback(PublishFn publish) {
    this.publish = publish;
    _regAspects.clear();
    _frameAspects.clear();
  }

  /// Clear the callback and aspects information of the model.
  void restoreCallback() {
    publish = dummyCallback;
    _regAspects.clear();
    _frameAspects.clear();
  }

  //* subMap section:
  /// Map of subscriber create methods of the model.
  final _subMap = HashMap<Object, Object>();

  /// static: Create a `Subscriber<Model>` widget by [mapKey] of `<Model>`.
  static SubscriberAuto<Model> sub<Model extends Pub>(Object mapKey,
      {Key? key}) {
    assert(ifModelTypeCorrect(Model, 'Pub.sub'));

    final model = Host.model<Model>();
    final sub = model._getSub<Model>(mapKey);
    return rxSub<Model>(sub, key: key);
  }

  /// Add a create method to the subMap with the key:[o].
  void regSub<Model extends Pub>(Object o, CreatorFn<Model> sub) {
    assert(ifModelTypeCorrect(Model, 'regSub'));
    assert(shouldNull(_subMap[o], 'regSub: Duplicate key, subMap[$o]'));

    _subMap[o] = sub;
  }

  /// Get the create method by the key:[o].
  CreatorFn<Model> _getSub<Model extends Pub>(Object o) {
    assert(ifModelTypeCorrect(Model, 'getSub'));
    assert(shouldExists(_subMap[o], 'getSub: subMap[$o] not exist'));
    assert(_subMap[o] is CreatorFn<Model>);

    return _subMap[o] as CreatorFn<Model>;
  }
  //! end subMap section

  //* conMap section:
  /// Map of controller create methods of the model.
  final _conMap = HashMap<Object, Object>();

  /// static: Create a `Controller<Model>` by [mapKey] of `<Model>`.
  static Controller<Model> controller<Model extends Pub>(Object mapKey,
      {Key? key}) {
    assert(ifModelTypeCorrect(Model, 'Pub.controller'));

    final model = Host.model<Model>();
    final con = model._getCon<Model>(mapKey);
    return Controller<Model>(
      create: con,
      key: key,
    );
  }

  /// Add a create method to the conMap with the key:[o].
  void regCon<Model extends Pub>(Object o, CreatorFn<Model> con) {
    assert(ifModelTypeCorrect(Model, 'regCon'));
    assert(shouldNull(_conMap[o], 'regCon: Duplicate key, conMap[$o]'));

    _conMap[o] = con;
  }

  /// Get the create method by the key:[o].
  CreatorFn<Model> _getCon<Model extends Pub>(Object o) {
    assert(ifModelTypeCorrect(Model, 'getCon'));
    assert(shouldExists(_conMap[o], 'getCon: conMap[$o] not exist'));
    assert(_conMap[o] is CreatorFn<Model>);

    return _conMap[o] as CreatorFn<Model>;
  }
  //! end subMap section
}

typedef PublishFn = void Function([Object aspects]);
// typedef PublishFn<AspectType> = void Function([AspectType aspects]);
