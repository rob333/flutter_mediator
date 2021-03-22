import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'pub.dart';
import 'rx/rx_impl.dart';
import 'subscriber.dart';

//* Class for monitoring global variables in the `Global Mode`.
// ignore: avoid_classes_with_only_static_members
class Global {
  static final Pub _globalPub = Pub();
  static Pub get globalPub => _globalPub;

  //* To memory the watched variables, then retrieve by `globalGet`.
  static final _globalWatchedVar = HashMap<Object, Object>();

  //* To monitor the variable and return a watched variable,
  //* i.e. a proxy object of type `Rx<T>`
  static Rx<T> watch<T>(T v, {Object? tag}) {
    final rx = Rx<T>(v);

    RxImpl.setPub(_globalPub);
    //* What Rximpl.setPub does:
    // for each rx added will be in the RxImpl.staticRxContainer, iterate with
    // rx.pub = globalPub;
    //* then clean the RxImpl.staticRxContainer
    // RxImpl.staticRxContainer.clear();

    //* Check if the variable [Type] or the [tag] already exists
    if (tag == null) {
      if (!_globalWatchedVar.containsKey(T)) {
        _globalWatchedVar[T] = rx;
        assert(() {
          print('Info: Global watched variable of Type: $T');
          return true;
        }());
      } else {
        assert(() {
          print('Info: Global watched variable of Type: $T already exists.');
          print(
              'If the watched variable would be used across files, please use the [tag] parameter.');
          return true;
        }());
      }
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

  //* To retrieve the watched variable by tag or Type `T`
  static Rx get<T>({Object? tag}) {
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
}

//* A helper function to monitor the variable and return a watched variable,
//* i.e. a proxy object of type `Rx<T>`
Rx<T> globalWatch<T>(T v, {Object? tag}) => Global.watch<T>(v, tag: tag);

Rx globalGet<T>({Object? tag}) {
  return Global.get<T>(tag: tag);
}

//* A helper function to create a widget for the watched variable,
//* to register the watched variable to the host to rebuild it when updating.
SubscriberLite globalConsume(Widget Function() create, {Key? key}) {
  return SubscriberLite<Pub>(key: key, create: create);
}
