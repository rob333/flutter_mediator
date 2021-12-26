import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_mediator/mediator.dart';

//* model class
class MyModel extends Pub {
  MyModel({required this.updateMs}) : assert(updateMs > 0) {
    resetTimer();
  }

  final int updateMs;
  Timer? updateTimer;

  int foo = 1;
  int bar = 2;
  int star = 3;

  /// `.rx` make the var automatically rebuild related widgets when updating.
  final _str1 = 's'.rx..addRxAspects('chainStr1'); // to chain react aspects
  String get str1 => _str1.value;
  set str1(String v) => _str1.value = v;

  /// `.rx` make the var automatically rebuild related widgets when updating.
  final _int1 = 0.rx;
  int get int1 => _int1.value;
  set int1(int v) => _int1.value = v;

  /// `.rx` make the var automatically rebuild related widgets when updating.
  final _tick1 = 0.rx;
  int get tick1 => _tick1.value;
  set tick1(int v) => _tick1.value = v;

  /// `.rx` make the var automatically rebuild related widgets when updating.
  final _tick2 = 0.rx;
  int get tick2 => _tick2.value;
  set tick2(int v) => _tick2.value = v;

  /// `.rx` make the var automatically rebuild related widgets when updating.
  final _tick3 = 0.rx;
  int get tick3 => _tick3.value;
  set tick3(int v) => _tick3.value = v;

  void increaseFoo() {
    foo += 1;
    publish('foo');
  }

  void increaseBar() {
    bar += 1;
    publish('bar');
  }

  void increaseBoth() {
    foo += 1;
    bar += 1;
    publish(['foo', 'bar']); // Publish multiple aspects manually.
  }

  void increaseAll() {
    foo += 1;
    bar += 1;
    star += 1;
    updateStr1();
    int1++;
    publish(); // Broadcasting, publish all aspects of the model.
  }

  static final chz = 'z'.codeUnitAt(0);
  static final chA = 'A'.codeUnitAt(0);
  void updateStr1() {
    var ch = str1.codeUnitAt(0);
    ch += 1;
    if (ch > chz) {
      ch = chA;
    }

    str1 = String.fromCharCode(ch); //
  }

  void updateInt1() {
    int1 += 1; // Automatically rebuild related widgets when updating.
  }

  Future<void> futureInt1() async {
    await Future.delayed(const Duration(seconds: 1));
    int1 += 1;
  }

  void updateNone() {
    publish('updateNone');
  }

  void resetTimer() {
    stopTimer();
    updateTimer = Timer.periodic(Duration(milliseconds: updateMs), (timer) {
      // _tick1.value++;
      tick1++;
      // publish('tick1'); // `_tick1` is a rx variable which will rebuild related widgets when updating.
      if (_tick1.value % 2 == 0) {
        tick2++;
        // publish('tick2'); // `_tick2` is a rx variable which will rebuild related widgets when updating.
        if (_tick2 % 2 == 0) {
          tick3++;
          // publish('tick3'); // `_tick3` is a rx variable which will rebuild related widgets when updating.
        }
      }
    });
  }

  void stopTimer() {
    if (updateTimer != null) {
      updateTimer?.cancel();
      updateTimer = null;
    }
  }

  //* View Map:
  void addSub(Object o, CreatorFn<MyModel> sub) => regSub<MyModel>(o, sub);
  void addCon(Object o, CreatorFn<MyModel> con) => regCon<MyModel>(o, con);

  @override
  void init() {
    addSub('int1AndStr1', (context, model) {
      return Text(
        'Int1 is ${model.int1} and Str1 is ${model.str1}',
        softWrap: true,
        textAlign: TextAlign.center,
      );
    });

    addSub('tick1', (context, model) {
      return Text('tick1 is ${model.tick1}');
    });

    super.init();
  }
  //! end section
}

//* MyModel extension
MyModel getMyModel(BuildContext context) => Host.model<MyModel>();

Subscriber<MyModel> subMyModel(CreatorFn<MyModel> create,
    {Key? key, Object? aspects}) {
  // return aspects.subModel<MyModel>(create, key: key);
  return Subscriber<MyModel>(key: key, aspects: aspects, create: create);
}

extension MyModelExtT<T> on T {
  Subscriber<MyModel> subMyModel(CreatorFn<MyModel> create, {Key? key}) {
    return Subscriber<MyModel>(key: key, aspects: this, create: create);
  }
}
