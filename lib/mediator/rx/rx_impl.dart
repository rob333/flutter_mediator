import 'package:flutter/widgets.dart';

import '../assert.dart';
import '../global.dart';
import '../pub.dart';

/// A proxy object class, for variables to turn into a watched one.
class RxImpl<T> {
  /// Constructor: add self to the static rx container
  /// and sholud use [setPub] to set the [Pub] when the model initialized.
  RxImpl(this._value) {
    // RxImpl(T initial) : _value = initial {
    ///
    /// variables and constructor calling sequence:
    /// 1. Model inline variables ->
    /// 2. Pub inline variables ->
    /// 3. Pub constructor ->
    /// 4. Model constructor
    staticRxContainer.add(this);
  }

  /// Constructor: With dedicated [Pub] parameter
  RxImpl.withPub(this._value, this._pub);
  // RxImpl.withPub(T initial, this.pub) : _value = initial;

  /// Constructor: With dedicated [Pub] and [tag] parameter
  /// if [tag] is null, then get an unique system tag for it.
  RxImpl.fullInitialize(this._value, this._pub, {int? tag}) {
    tag ??= _nextRxTag();
    _addRxTag(tag);
  }

  //* region member variables
  Pub? _pub; // the [Pub] attached to this rx variable
  final rxAspects = <Object>{}; // aspects attached to this rx variable
  bool _isNullBroadcast = false; // if this rx variable is broadcasting

  T _value; // the underlying value with template type T
  final _tag = <int>{}; // As of v2.1.2+3 changes to `int` tag.

  //* region static section
  static final List<RxImpl> staticRxContainer = [];

  /// set observer for each rx variable
  static void setPub(Pub pub) {
    for (final element in staticRxContainer) {
      element._pub = pub;
    }
    staticRxContainer.clear();
  }

  /// in case member variables initialized inside constructor, or member functions.
  static Pub? statePub;
  static void enableVarCollect(Pub pub) => statePub = pub;
  static void disableVarCollect() {
    setPub(statePub!); // set observer for every rx variable
    statePub = null;
  }

  /// static aspects and the flag of if enabled
  static Iterable<Object>? stateWidgetAspects;
  static bool stateWidgetAspectsFlag = false;

  /// enable auto add static aspects to aspects of rx - by getter
  static void enableCollectAspect(Iterable<Object>? widgetAspects) {
    stateWidgetAspects = widgetAspects;
    stateWidgetAspectsFlag = true;
  }

  /// disable auto add static aspects to aspects of rx - by getter
  static void disableCollectAspect() {
    stateWidgetAspects = null;
    stateWidgetAspectsFlag = false;
  }
  //! endregion

  //* region rx auto aspect static section
  static int rxTagCounter = 0;
  static int _nextRxTag() {
    assert(ifTagMaximum(rxTagCounter));
    // return numToString128(rxTagCounter++); // As of v2.1.2+3 changes to `int` tag.
    return rxTagCounter++;
  }

  static bool stateRxAutoAspectFlag = false;
  static List<Object> stateRxAutoAspects = [];

  static void enableRxAutoAspect() => stateRxAutoAspectFlag = true;
  static void disableRxAutoAspect() => stateRxAutoAspectFlag = false;
  static List<Object> getRxAutoAspects() => stateRxAutoAspects;
  static void clearRxAutoAspects() => stateRxAutoAspects.clear();
  // get RxAutoAspects and disable RxAutoAspectFlag
  static List<Object> getAndDisableRxAutoAspect() {
    stateRxAutoAspectFlag = false;
    return stateRxAutoAspects;
  }

  /// disable RxAutoAspectFlag And clear RxAutoAspects
  static void disableAndClearRxAutoAspect() {
    stateRxAutoAspectFlag = false;
    stateRxAutoAspects.clear();
  }
  //! endregion

  /// getter: Return the value of the underlying object.
  T get value {
    // if rx automatic aspect is enabled. (precede over state rx aspect)
    if (stateRxAutoAspectFlag == true) {
      touch(); // Touch to activate rx automatic aspect management.
      //
    } else if (stateWidgetAspectsFlag == true) {
      if (stateWidgetAspects != null) {
        rxAspects.addAll(stateWidgetAspects!);
      } else {
        _isNullBroadcast = true;
      }
    }

    return _value;
  }

  /// setter: Set the value of the underlying object.
  set value(T value) {
    if (_value != value) {
      _value = value;
      assert(_pub != null);
      // if (pub != null) {
      publishRxAspects();
      // }
    }
  }

  /// Notify the host to rebuild related consume widget and then return
  /// the underlying object.
  ///
  /// Suitable for class type [_value], like List, Map, Set, and class.
  ///
  /// ex. var is a int List: `<int>[]`,
  ///
  ///     var.ob.add(1); // to notify the host to rebuild related consume widget.
  T get ob {
    publishRxAspects();
    return _value;
  }

  /// Touch to activate rx automatic aspect management.
  void touch() {
    // if _tag is empty, this is the first time. (lazy _tag initialization)
    if (_tag.isEmpty) {
      final tag = _nextRxTag();
      _addRxTag(tag);
    }
    // add the [rxAspects] to the rx automatic aspect list,
    // for later getRxAutoAspects() to register to [Host]
    stateRxAutoAspects.addAll(rxAspects);
  }

  /// Add an unique system `tag` to the Rx object.
  void _addRxTag(int tag) {
    // Add the tag to the Rx tag list.
    _tag.add(tag);
    // Add the tag to the registered aspects of the model.
    assert(_pub != null);
    _pub!.regAspects.add(tag);
    // Add the tag to the Rx Aspects list.
    rxAspects.add(tag);
  }

  /// A helper function to `touch()` itself first and then `globalConsume`.
  Widget consume(Widget Function() create, {Key? key}) {
    final wrapFn = () {
      touch();
      return create();
    };
    return globalConsume(wrapFn, key: key);
  }

  /// Add [aspects] to the Rx aspects.
  /// param aspects:
  ///   Iterable: add [aspects] to the rx aspects
  ///   null: broadcast to the model
  /// RxImpl: add [(aspects as RxImpl).rxAspects] to the rx aspects
  ///       : add `aspects` to the rx aspects
  void addRxAspects([Object? aspects]) {
    if (aspects is Iterable<Object>) {
      rxAspects.addAll(aspects);
    } else if (aspects == null) {
      _isNullBroadcast = true;
    } else if (aspects is RxImpl) {
      rxAspects.addAll(aspects.rxAspects);
    } else {
      rxAspects.add(aspects);
    }
  }

  /// Remove [aspects] from the Rx aspects.
  /// param aspects:
  ///   Iterable: remove [aspects] from the rx aspects
  ///   null: don't broadcast to the model
  /// RxImpl: remove [(aspects as RxImpl).rxAspects] from the rx aspects
  ///       : remove `aspects` from the rx aspects
  void removeRxAspects([Object? aspects]) {
    if (aspects is Iterable<Object>) {
      rxAspects.removeAll(aspects);
    } else if (aspects == null) {
      _isNullBroadcast = false;
    } else if (aspects is RxImpl) {
      rxAspects.removeAll(aspects.rxAspects);
    } else {
      rxAspects.remove(aspects);
    }
  }

  /// Retain [aspects] in the Rx aspects.
  /// param aspects:
  ///   Iterable: retain rx aspects in the [aspects]
  ///     RxImpl: retain rx aspects in the [(aspects as RxImpl).rxAspects]
  ///           : retain rx aspects in the `aspects`
  void retainRxAspects(Object aspects) {
    if (aspects is Iterable) {
      rxAspects.retainAll(aspects);
    } else if (aspects is RxImpl) {
      rxAspects.retainAll(aspects.rxAspects);
    } else {
      rxAspects.retainWhere((element) => element == aspects);
    }
  }

  /// Clear all the Rx aspects.
  void clearRxAspects() => rxAspects.clear();

  /// Copy info from another Rx variable.
  void copyInfo(RxImpl<T> other) {
    _tag.addAll(other._tag);
    _pub = other._pub;
    rxAspects.addAll(other.rxAspects);
  }

  /// Publish Rx aspects to the host.
  void publishRxAspects() {
    assert(shouldExists(_pub, 'Pub of RxImpl should not be null.'));
    if (_isNullBroadcast) {
      return _pub!.publish();
    } else if (rxAspects.isNotEmpty) {
      return _pub!.publish(rxAspects);
    }
  }

  /// Synonym of `publishRxAspects()`.
  void notify() => publishRxAspects();

  /// RxVar(newVal): set new value to the Rx underlying value.
  /// dart:call() works in the same way as operator()
  T call(T v) {
    // if (v != null) {
    value = v;
    // }
    return value;
  }

  //* override method
  @override
  String toString() => _value.toString();
}

/// Rx class for `bool` Type.
class RxBool extends RxImpl<bool> {
  RxBool([bool initial = false]) : super(initial);

  bool operator &(bool other) => other && value;

  bool operator |(bool other) => other || value;

  bool operator ^(bool other) => !other == value;

  @override
  String toString() => _value.toString();
}

/// Rx class for `String` Type.
class RxString extends RxImpl<String> {
  RxString([String initial = '']) : super(initial);

  String operator +(String val) => _value + val;
  int codeUnitAt(int index) => _value.codeUnitAt(index);
}

/// Rx<T> class
class Rx<T> extends RxImpl<T> {
  /// Constructor: With `initial` as initial value.
  Rx(T initial) : super(initial);

  /// Constructor: With [Pub] `pub` as the model.
  Rx.withPub(T initial, Pub pub) : super.withPub(initial, pub);

  /// Constructor: With dedicated [Pub] and [tag] parameter
  /// if [tag] is null, then get an unique system tag for it.
  Rx.fullInitialize(T initial, Pub pub, {int? tag})
      : super.fullInitialize(initial, pub, tag: tag);
}

/// Helper Extension:
/// Helper for string type to Rx object.
extension RxStringExtension on String {
  /// Returns a `RxString` with [this] `String` as initial value.
  RxString get rx => RxString(this);
}

/// Helper for bool type to Rx object.
extension RxBoolExtension on bool {
  /// Returns a `RxBool` with [this] `bool` as initial value.
  RxBool get rx => RxBool(this);
}

/// Helper for all others type to Rx object.
extension RxExtension<T> on T {
  /// Returns a `Rx` instace with [this] `T` as initial value.
  Rx<T> get rx => Rx<T>(this);
}

/// Encode a number into a string
String numToString128(int value) {
  /// ascii code:
  /// 32: space /// 33: !  (first character except space)
  /// 48: 0
  /// 65: A  /// 90: Z
  /// 97: a  /// 122
  // const int charBase = 33;
  //'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#%&()*+,-./:;<=>?@[\\]^_`{|}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ';
  const charBase =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#%&()*+,-./:;<=>?@[]^_`{|}~€‚ƒ„…†‡•–™¢£¤¥©®±µ¶º»¼½¾ÀÆÇÈÌÐÑÒ×ØÙÝÞßæç';
  assert(charBase.length >= 128, 'numToString128 const charBase length < 128');

  if (value == 0) {
    return '#0';
  }

  var res = '#';

  assert(value >= 0, 'numToString should provide positive value.');
  // if (value < 0) {
  //   value = -value;
  //   res += '-';
  // }

  final list = <String>[];
  while (value > 0) {
    /// 64 group
    // final remainder = value & 63;
    // value = value >> 6; // == divide by 64

    /// 128 group
    final remainder = value & 127;
    value = value >> 7; // == divide by 128
    /// num to char, base on charBase
    //final char = String.fromCharCode(remainder + charBase);
    final char = charBase[remainder];
    list.add(char);
  }

  for (var i = list.length - 1; i >= 0; i--) {
    res += list[i];
  }

  return res;
}
