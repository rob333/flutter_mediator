import 'package:flutter/widgets.dart';

import '../mediator.dart';

class MultiHost {
  static Widget create1<T1 extends Publisher>(
    T1 t1, {
    @required Widget child,
  }) {
    return Host(model: t1, child: child);
  }

  static Widget create2<T1 extends Publisher, T2 extends Publisher>(
    T1 t1,
    T2 t2, {
    @required Widget child,
  }) {
    child = Host(model: t2, child: child);
    child = Host(model: t1, child: child);
    return child;
  }

  static Widget
      create3<T1 extends Publisher, T2 extends Publisher, T3 extends Publisher>(
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

  static Widget create4<T1 extends Publisher, T2 extends Publisher,
      T3 extends Publisher, T4 extends Publisher>(
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

  static Widget create5<T1 extends Publisher, T2 extends Publisher,
      T3 extends Publisher, T4 extends Publisher, T5 extends Publisher>(
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

  static Widget create6<
      T1 extends Publisher,
      T2 extends Publisher,
      T3 extends Publisher,
      T4 extends Publisher,
      T5 extends Publisher,
      T6 extends Publisher>(
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

  static Widget create7<
      T1 extends Publisher,
      T2 extends Publisher,
      T3 extends Publisher,
      T4 extends Publisher,
      T5 extends Publisher,
      T6 extends Publisher,
      T7 extends Publisher>(
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
      T1 extends Publisher,
      T2 extends Publisher,
      T3 extends Publisher,
      T4 extends Publisher,
      T5 extends Publisher,
      T6 extends Publisher,
      T7 extends Publisher,
      T8 extends Publisher>(
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
      T1 extends Publisher,
      T2 extends Publisher,
      T3 extends Publisher,
      T4 extends Publisher,
      T5 extends Publisher,
      T6 extends Publisher,
      T7 extends Publisher,
      T8 extends Publisher,
      T9 extends Publisher>(
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

  // static Widget create(List<Publisher> list, {@required Widget child}) {
  //   for (var i = list.length - 1; i >= 0; i--) {
  //     // dart template infer model as type of Publisher instead of the original type
  //     // so the InheritedModel will miss getting the model back
  //     child = Host(model: list[i], child: child);
  //   }
  //   return child;
  // }
}
