import 'package:flutter/widgets.dart';

import '../mediator.dart';

class MultiHost {
  static Widget create1<T1 extends Pub>(
    T1 t1, {
    @required Widget child,
  }) {
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget create2<T1 extends Pub, T2 extends Pub>(
    T1 t1,
    T2 t2, {
    @required Widget child,
  }) {
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget create3<T1 extends Pub, T2 extends Pub, T3 extends Pub>(
    T1 t1,
    T2 t2,
    T3 t3, {
    @required Widget child,
  }) {
    child = Host(model: t3, child: child);
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget
      create4<T1 extends Pub, T2 extends Pub, T3 extends Pub, T4 extends Pub>(
    T1 t1,
    T2 t2,
    T3 t3,
    T4 t4, {
    @required Widget child,
  }) {
    child = Host(model: t4, child: child);
    child = Host(model: t3, child: child);
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget create5<T1 extends Pub, T2 extends Pub, T3 extends Pub,
      T4 extends Pub, T5 extends Pub>(
    T1 t1,
    T2 t2,
    T3 t3,
    T4 t4,
    T5 t5, {
    @required Widget child,
  }) {
    child = Host(model: t5, child: child);
    child = Host(model: t4, child: child);
    child = Host(model: t3, child: child);
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget create6<T1 extends Pub, T2 extends Pub, T3 extends Pub,
      T4 extends Pub, T5 extends Pub, T6 extends Pub>(
    T1 t1,
    T2 t2,
    T3 t3,
    T4 t4,
    T5 t5,
    T6 t6, {
    @required Widget child,
  }) {
    child = Host(model: t6, child: child);
    child = Host(model: t5, child: child);
    child = Host(model: t4, child: child);
    child = Host(model: t3, child: child);
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget create7<T1 extends Pub, T2 extends Pub, T3 extends Pub,
      T4 extends Pub, T5 extends Pub, T6 extends Pub, T7 extends Pub>(
    T1 t1,
    T2 t2,
    T3 t3,
    T4 t4,
    T5 t5,
    T6 t6,
    T7 t7, {
    @required Widget child,
  }) {
    child = Host(model: t7, child: child);
    child = Host(model: t6, child: child);
    child = Host(model: t5, child: child);
    child = Host(model: t4, child: child);
    child = Host(model: t3, child: child);
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget create8<
      T1 extends Pub,
      T2 extends Pub,
      T3 extends Pub,
      T4 extends Pub,
      T5 extends Pub,
      T6 extends Pub,
      T7 extends Pub,
      T8 extends Pub>(
    T1 t1,
    T2 t2,
    T3 t3,
    T4 t4,
    T5 t5,
    T6 t6,
    T7 t7,
    T8 t8, {
    @required Widget child,
  }) {
    child = Host(model: t8, child: child);
    child = Host(model: t7, child: child);
    child = Host(model: t6, child: child);
    child = Host(model: t5, child: child);
    child = Host(model: t4, child: child);
    child = Host(model: t3, child: child);
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget create9<
      T1 extends Pub,
      T2 extends Pub,
      T3 extends Pub,
      T4 extends Pub,
      T5 extends Pub,
      T6 extends Pub,
      T7 extends Pub,
      T8 extends Pub,
      T9 extends Pub>(
    T1 t1,
    T2 t2,
    T3 t3,
    T4 t4,
    T5 t5,
    T6 t6,
    T7 t7,
    T8 t8,
    T9 t9, {
    @required Widget child,
  }) {
    child = Host(model: t9, child: child);
    child = Host(model: t8, child: child);
    child = Host(model: t7, child: child);
    child = Host(model: t6, child: child);
    child = Host(model: t5, child: child);
    child = Host(model: t4, child: child);
    child = Host(model: t3, child: child);
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  // static Widget create(List<Pub> pubs, {@required Widget child}) {
  //   for (var i = pubs.length - 1; i >= 0; i--) {
  //     // dart template infer pubs[i]:model as type of Pub instead of the original type
  //     // so the InheritedModel will miss getting the model back
  //     child = Host(model: pubs[i], child: child);
  //   }
  //   return child;
  // }
}

// T cast<T>(x) => x is T ? x : null;
// T cast<T>(dynamic x, {T fallback}) => x is T ? x : fallback;
