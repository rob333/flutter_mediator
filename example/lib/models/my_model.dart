import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mediator/mediator.dart';

//* Helper function of MyModel
MyModel getMyModel(BuildContext context) {
  return Host.getInheritOfModel<MyModel>(context);
}

Subscriber<MyModel> subMyModel(CreaterOfSubscriber<MyModel> create,
    {Key key, Object aspects}) {
  // return aspects.subModel<MyModel>(create, key: key);
  return Subscriber<MyModel>(key: key, aspects: aspects, create: create);
}

extension MyModelHelperT<T> on T {
  Subscriber<MyModel> subMyModel(CreaterOfSubscriber<MyModel> create,
      {Key key}) {
    return Subscriber<MyModel>(key: key, aspects: this, create: create);
  }
}

//* model class
class MyModel extends Publisher {
  MyModel({this.updateMs}) : assert(updateMs > 0) {
    resetTimer();
  }

  final int updateMs;
  // `.rx` make the var automatically rebuild the widget when updated
  var _foo = 1.rx;
  var _bar = 2.rx;
  var _star = 3.rx;

  final str1 = 's'.rx..addRxAspects('chainStr1'); // to chain react aspects
  var int1 = 0.rx;

  Timer updateTimer;
  var _tick1 = 0.rx;
  var _tick2 = 0.rx;
  int _tick3 = 0;

  int get foo => _foo.value;
  int get bar => _bar.value;
  int get star => _star.value;

  set foo(int value) {
    _foo(value); // update rx variable by call() style
    /// is the same as
    // _foo = value;
    /// is the same as
    // _foo.value = value;

    // manually publish the aspect
    // _foo is Rx, automatically update aspect related widgets
    // publish('foo');
  }

  set bar(int value) {
    // update Rx by setting the underlying value
    _bar.value = value;

    // manually publish the aspect
    // _bar is Rx, automatically update aspect related widgets
    // publish('bar');
  }

  void increaseBoth() {
    _foo += 1;
    _bar += 1;

    publish(['foo', 'bar']); // manually publish multiple aspects in a list
  }

  void increaseAll() {
    _foo += 1;
    _bar += 1;
    _star += 1;
    updateStr1();
    int1.value++;
    publish(); // manually publish all aspects of the model
  }

  static final chz = 'z'.codeUnitAt(0);
  static final chA = 'A'.codeUnitAt(0);
  void updateStr1() {
    var ch = str1.codeUnitAt(0);
    ch += 1;
    if (ch > chz) {
      ch = chA;
    }

    str1(String.fromCharCode(ch));
    // str1.value = String.fromCharCode(ch);
  }

  void updateInt1() {
    int1 += 1; // automatically update aspect related widgets
    /// is the same as
    // int1.value += 1; // automatically update aspect related widgets
  }

  Future<void> futureInt1() async {
    await Future.delayed(const Duration(seconds: 1));
    int1 += 1; // int1 is Rx, automatically update aspect related widgets
  }

  void updateNone() {
    publish('updateNone');
  }

  int get tick1 => _tick1.value;
  int get tick2 => _tick2.value;
  int get tick3 => _tick3;

  set tick1(int value) {
    _tick1.value = value;
    // publish('tick1');
  }

  set tick2(int value) {
    _tick2.value = value;
    // publish('tick2');
  }

  set tick3(int value) {
    _tick3 = value;
    publish('tick3');
  }

  void resetTimer() {
    stopTimer();
    updateTimer = Timer.periodic(Duration(milliseconds: updateMs), (timer) {
      // _tick1.value++;
      _tick1++;
      // publish('tick1');
      if (_tick1.value % 2 == 0) {
        _tick2++;
        // publish('tick2');
        if (_tick2 % 2 == 0) {
          _tick3++;
          publish('tick3');
        }
      }
    });
  }

  void stopTimer() {
    updateTimer?.cancel();
  }
}
