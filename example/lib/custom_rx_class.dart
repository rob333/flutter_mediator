import 'package:flutter_mediator/mediator/rx/rx.dart';

class SomeClass {
  int counter = 0;
}

class RxCustom extends RxImpl {
  RxCustom(SomeClass initial) : super(initial);

  void updateData(int val) {
    value.counter += val;
    publishRxAspects();
  }
}

extension RxCustomExtension on SomeClass {
  RxCustom get rx => RxCustom(this);
}
