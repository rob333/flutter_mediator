import 'package:flutter_mediator/mediator/rx/rx.dart';

class RxCustomClassData {
  int data = 0;
}

class RxCustomClass extends RxImpl {
  RxCustomClass([RxCustomClassData initial]) : super(initial);

  void updateClassData(int val) {
    value.data += val;
    publishRxAspects();
  }
}

extension RxCustomClassExtension on RxCustomClassData {
  RxCustomClass get rx => RxCustomClass(this);
}
