import 'package:flutter/widgets.dart';

import 'pub.dart';
import 'rx/rx_impl.dart';
import 'subscriber.dart';

//* Class for monitoring global variables as `Global Mode`.
// ignore: avoid_classes_with_only_static_members
class Global {
  static Pub globalPub = Pub();

  static Rx<T> watch<T>(T v) {
    final rx = Rx<T>(v);

    RxImpl.setPub(globalPub);
    //* What Rximpl.setPub does:
    // for each rx added will be in the RxImpl.staticRxContainer, iterate with
    // rx.pub = globalPub;
    //* then clean the RxImpl.staticRxContainer
    // RxImpl.staticRxContainer.clear();

    return rx;
  }
}

//* A helper function to monitor the variable and return a watched variable,
//* i.e. a proxy object of type `Rx<T>`
Rx<T> globalWatch<T>(T v) => Global.watch<T>(v);

//* A helper function to create a widget for the watched variable,
//* i.e. register the watched variable to the host to rebuild the widget when updating.
SubscriberLite globalConsume(Widget Function() create, {Key? key}) {
  return SubscriberLite<Pub>(key: key, create: create);
}
