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
    _addTag();
    staticRxContainer.add(this);
  }

  /// Constructor: With dedicated [Pub] parameter
  RxImpl.withPub(this._value, this._pub) {
    _addTag();
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
      pub.regAspects.addAll(element._tag);
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

  /// Return the next unique system tag.
  static int _nextRxTag() {
    assert(ifTagMaximum(rxTagCounter));
    // return numToString128(rxTagCounter++); // As of Mediator v2.1.2+3 changes to `int` tag.
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

  /// Getter:
  ///
  /// Return the value of the underlying object.
  ///
  /// The value used inside the consumer widget will cause the widget
  /// to rebuild when updating; or use
  ///
  ///     watchedVar.consume(() => widget)
  /// to `touch()` the watched variable itself first and then `globalConsume(() => widget)`.
  get value {
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

    if (_value is! Function) {
      return _value;
    }
    // This is a computed mediator variable.
    final fn = _value as Function;
    final res = fn();
    return res;
  }

  /// Setter:
  ///
  /// Set the value of the underlying object.
  ///
  /// Update to the value will notify the host to rebuild;
  /// or the underlying object would be a class, then use
  ///
  /// `watchedVar.ob.updateMethod(...)` to notify the host to rebuild.
  ///
  ///     watchedVar.ob = watchedVar.notify() and then return the underlying object
  set value(value) {
    if (_value != value) {
      _value = value;
      assert(_pub != null);
      // if (pub != null) {
      publishRxAspects();
      // }
    }
  }

  /// Notify the host to rebuild related consumer widget and then return
  /// the underlying object.
  ///
  /// Suitable for class type [_value], like List, Map, Set, and class.
  ///
  /// ex. var is a int List: `<int>[]`,
  ///
  ///     var.ob.add(1); // to notify the host to rebuild related consumer widget.
  T get ob {
    publishRxAspects();
    return _value;
  }

  /// Activate automatic aspect management for this watched variable.
  void touch() {
    // add the [rxAspects] to the rx automatic aspect list,
    // for later getRxAutoAspects() to register to [Host]
    stateRxAutoAspects.addAll(rxAspects);
  }

  /// Add an unique system `tag` to this Rx object.
  void _addTag() {
    final tag = _nextRxTag();

    // Add the tag to the Rx tag list.
    _tag.add(tag);
    // Add the tag to the Rx Aspects list.
    rxAspects.add(tag);

    // Add the tag to the registered aspects of the model.
    // assert(_pub != null);
    // _pub!.regAspects.add(tag);
    _pub?.regAspects.add(tag);
  }

  /// Create a consumer widget and connect with the watched variable.
  /// The consumer widget will rebuild whenever the watched variable updates.
  ///
  /// e.g.
  ///
  ///     watchedVar.consume(() => widget)
  /// is to `touch()` the watched variable itself first and then
  /// `globalConsume(() => widget)`.
  Widget consume(Widget Function() create, {Key? key}) {
    wrapFn() {
      touch();
      return create();
    }

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
}

/// Extension for string type to Rx object.
extension RxStringExt on String {
  /// Returns a `RxString` with [this] `String` as initial value.
  RxString get rx => RxString(this);
}

/// Extension for bool type to Rx object.
extension RxBoolExt on bool {
  /// Returns a `RxBool` with [this] `bool` as initial value.
  RxBool get rx => RxBool(this);
}

/// Extension for all others type to Rx object.
extension RxExt<T> on T {
  /// Returns a `Rx` instace with [this] `T` as initial value.
  Rx<T> get rx => Rx<T>(this);
}

/// type alias
typedef Signal<T> = Rx<T>;

/// Extension for Signal type aliase.
extension SignalExt<T> on T {
  /// Returns a `Signal` type alias with [this] of type `T` as the initial value.
  Signal<T> get signal => Signal<T>(this);
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
