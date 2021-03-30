import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'pub.dart';
import 'rx/rx_impl.dart';
import 'subscriber.dart';

/// The global model for containing global variables of the `Global Mode`.
final Pub _globalPub = Pub();

/// A getter, to return the global pub of the `Global Mode`.
Pub get globalPub => _globalPub;

/// Memory the watched variables, retrieved by [globalGet].
final _globalWatchedVar = HashMap<Object, Object>();

/// Create a watched variable from the variable [v],
/// a proxy object of the Type of [Rx<T>]
Rx<T> globalWatch<T>(T v, {Object? tag}) {
  final rx = Rx.fullInitialize(v, _globalPub);

  //* Check if the variable [Type] or the [tag] already exists
  if (tag == null) {
    if (!_globalWatchedVar.containsKey(T)) {
      _globalWatchedVar[T] = rx;
      assert(() {
        print('Info: Global watched variable of Type: $T');
        return true;
      }());
    }
    /*
    else {
      assert(() {
        print('Info: Global watched variable of Type: $T already exists.');
        print(
            'If the watched variable would be used across files, please use the [tag] parameter.');
        return true;
      }());
    }
    */
  } else {
    if (!_globalWatchedVar.containsKey(tag)) {
      _globalWatchedVar[tag] = rx;
    } else {
      throw FlutterError(
          'Error: Global watched variable of tag:$tag already exists.');
    }
  }

  return rx;
}

/// Retrieve the watched variable by [tag] or `Type` of [T]
Rx globalGet<T>({Object? tag}) {
  if (tag == null) {
    assert(() {
      if (_globalWatchedVar[T] == null)
        throw FlutterError(
            'Error: `globalGet` gets null. Type:$T does not exists.');
      return true;
    }());
    return _globalWatchedVar[T] as Rx<T>;
  }
  assert(() {
    if (_globalWatchedVar[tag] == null)
      throw FlutterError(
          'Error: `globalGet` gets null. Tag:$tag does not exists.');
    return true;
  }());
  return _globalWatchedVar[tag] as Rx;
}

/// A helper function to create a widget for the watched variable,
/// and register it to the host to rebuild the widget when updating.
SubscriberLite globalConsume(Widget Function() create, {Key? key}) {
  return SubscriberLite<Pub>(key: key, create: create);
}

/// Broadcast to all the globalConsume widgets.
void globalBroadcast() => _globalPub.publish();

/// Create a widget that will be rebuilt whenever any watched variables
/// changes are made.
Subscriber globalConsumeAll(Widget Function() create, {Key? key}) {
  final wrapFn = (BuildContext _, Pub __) => create();
  return Subscriber<Pub>(key: key, create: wrapFn);
}

/// Return the updated aspects of the `Global Mode`.
HashSet<Object> get globalFrameAspects => _globalPub.frameAspects;

/// Return all the aspects that has been registered to the `Global Mode`.
HashSet<Object> get globalAllAspects => _globalPub.regAspects;
