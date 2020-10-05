import '../mediator_publisher.dart';

class RxImpl<T> {
  //* constructor
  RxImpl([T initial]) : _value = initial {
    // variables and constructor calling sequence:
    // 1. Model inline variables ->
    // 2. Publisher inline variables ->
    // 3. Publisher constructor ->
    // 4. Model constructor
    staticContainer.add(this);
  }

  //* static section
  static final List<RxImpl> staticContainer = [];

  /// set observer for each rx variable
  static void setPublisher(Publisher pub) {
    void fn(element) => element.publisher = pub;
    staticContainer.forEach(fn);
    staticContainer.clear();
  }

  //* in case member variables initialized inside constructor, or member functions.
  static Publisher statePublisher;
  static void enableVarCollect(Publisher pub) => statePublisher = pub;
  static void disableVarCollect() {
    setPublisher(statePublisher); // set observer for every rx variable
    statePublisher = null;
  }
  //* end section

  /// static aspects and the flag of if enabled
  static Iterable stateRxAspects;
  static bool stateRxAspectsFlag = false;

  /// enable auto add static aspects to aspects of rx - by getter
  static void enableCollectAspect(Iterable widgetAspects) {
    stateRxAspects = widgetAspects;
    stateRxAspectsFlag = true;
  }

  /// disable auto add static aspects to aspects of rx - by getter
  static void disableCollectAspect() {
    stateRxAspects = null;
    stateRxAspectsFlag = false;
  }

  //* member variables
  Publisher publisher; // the publisher that attach to this rx variable
  final Set rxAspects = {}; // the aspects that attach to this rx variable
  bool isNullBroadcast = false; // if this rx variable is broadcasting

  T _value; // the underlying value with template type T

  //* setter value
  set value(T value) {
    if (_value != value) {
      _value = value;
      if (publisher == null) return;
      publishRxAspects();
    }
  }

  //* getter value
  T get value {
    if (stateRxAspectsFlag == true) {
      if (stateRxAspects != null) {
        rxAspects.addAll(stateRxAspects);
      } else {
        isNullBroadcast = true;
      }
    }

    return _value;
  }

  /// add [aspects] to the rx aspects.
  /// param aspects:
  ///   Iterable: add [aspects] to the rx aspects
  ///   null: broadcast to the model - the publisher
  /// RxImpl: add [(aspects as RxImpl).rxAspects] to the rx aspects
  ///       : add `aspects` to the rx aspects
  void addRxAspects([Object aspects]) {
    if (aspects is Iterable) {
      rxAspects.addAll(aspects);
    } else if (aspects == null) {
      isNullBroadcast = true;
    } else if (aspects is RxImpl) {
      rxAspects.addAll(aspects.rxAspects);
    } else {
      rxAspects.add(aspects);
    }
  }

  /// remove [aspects] from the rx aspects.
  /// param aspects:
  ///   Iterable: remove [aspects] from the rx aspects
  ///   null: don't broadcast to the model - the publisher
  /// RxImpl: remove [(aspects as RxImpl).rxAspects] from the rx aspects
  ///       : remove `aspects` from the rx aspects
  void removeRxAspects([Object aspects]) {
    if (aspects is Iterable) {
      rxAspects.removeAll(aspects);
    } else if (aspects == null) {
      isNullBroadcast = false;
    } else if (aspects is RxImpl) {
      rxAspects.removeAll(aspects.rxAspects);
    } else {
      rxAspects.remove(aspects);
    }
  }

  /// retain [aspects] in the rx aspects.
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

  /// clear all rx aspects
  void clearRxAspects() => rxAspects.clear();

  /// copy info from another rx variable
  void copyInfo(RxImpl<T> other) {
    publisher = other.publisher;
    rxAspects.addAll(other.rxAspects);
  }

  /// publish rx aspects to host
  void publishRxAspects() {
    assert(publisher != null, 'Publisher in the RxImpl should not be null.');
    if (isNullBroadcast) {
      return publisher.publish();
    } else if (rxAspects.isNotEmpty) {
      return publisher.publish(rxAspects);
    }
  }

  /// RxVar(newVal): set new value to the Rx underlying value.
  /// dart:call() works in the same way as operator()
  T call([T v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  //* override method
  @override
  String toString() => value.toString();

  /// This equality override works for RxImpl instances and the internal
  /// values.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(dynamic o) {
    if (o is T) return value == o;
    if (o is RxImpl<T>) return value == o.value;
    return false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    // return hashCode;
    if (_value == null) {
      // ignore: recursive_getters
      return hashCode;
    }
    return _value.hashCode;
  }
}

//* Rx class for `bool` Type.
class RxBool extends RxImpl<bool> {
  RxBool([bool initial]) : super(initial);

  bool operator &(bool other) => other && value;

  bool operator |(bool other) => other || value;

  bool operator ^(bool other) => !other == value;

  @override
  String toString() => _value.toString();
}

//* Rx class for `String` Type.
class RxString extends RxImpl<String> {
  RxString([String initial]) : super(initial);

  String operator +(String val) => _value + val;
  int codeUnitAt(int index) => _value.codeUnitAt(index);
}

//* Rx<T> class
class Rx<T> extends RxImpl<T> {
  Rx([T initial]) : super(initial);
}

//* extension helper
extension RxStringExtension on String {
  /// Returns a `RxString` with [this] `String` as initial value.
  RxString get rx => RxString(this);
}

extension RxBoolExtension on bool {
  /// Returns a `RxBool` with [this] `bool` as initial value.
  RxBool get rx => RxBool(this);
}

extension RxExtension<T> on T {
  /// Returns a `Rx` instace with [this] `T` as initial value.
  Rx<T> get rx => Rx<T>(this);
}
