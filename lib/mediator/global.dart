import 'package:flutter/widgets.dart';

import 'pub.dart';
import 'rx/rx_impl.dart';
import 'subscriber.dart';

// ignore: avoid_classes_with_only_static_members
/// Class for monitoring global variables as `Global Mode`.
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

//* A helper function to monitor the variable and return a proxy object: Rx<T>
Rx<T> globalWatch<T>(T v) => Global.watch<T>(v);

//* A helper function to consume the variable of the proxy object.
//* i.e. Register the variable to the host, rebuild the widget when updates.
Subscriber<Pub> globalConsume(Widget Function() fn, {Key? key}) {
  return rxSub<Pub>((context, model) => fn(), key: key);
}

extension RxImplConsumeExt on RxImpl {
  //* A helper function to `touch()` itself first then `globalConsume`.
  //! Depends on `globalConsume`
  Widget consume(Widget Function() fn, {Key? key}) {
    // final wrapFn = () {
    //   touch();
    //   return fn();
    // };
    // return globalConsume(wrapFn, key: key);
    final Widget Function(BuildContext c, Pub m) wrapFn = (c, m) {
      touch();
      return fn();
    };
    return rxSub<Pub>(wrapFn, key: key);
  }
}
