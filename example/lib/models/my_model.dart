import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_mediator/mediator.dart';

//* model class
class MyModel extends Pub {
  MyModel({this.updateMs}) : assert(updateMs > 0) {
    resetTimer();
  }

  final int updateMs;

  /// `.rx` turn the variable into a proxy object,
  /// make the var automatically rebuild the widget when updated
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

    // publish('foo'); // `foo` is a rx variable, will publish automatically.
  }

  set bar(int value) {
    // update rx by setting the underlying value
    _bar.value = value;
  }

  void increaseBoth() {
    _foo += 1;
    _bar += 1;

    publish(['foo', 'bar']); // manually publish multiple aspects
  }

  void increaseAll() {
    _foo += 1;
    _bar += 1;
    _star += 1;
    updateStr1();
    int1++;
    publish(); // broadcasting, publish all aspects of the model
  }

  static final chz = 'z'.codeUnitAt(0);
  static final chA = 'A'.codeUnitAt(0);
  void updateStr1() {
    var ch = str1.codeUnitAt(0);
    ch += 1;
    if (ch > chz) {
      ch = chA;
    }

    str1(String.fromCharCode(ch)); //
    /// is the same as
    // str1.value = String.fromCharCode(ch);
  }

  void updateInt1() {
    int1 += 1; // automatically update the rx related widget when updated
    /// is the same as
    // int1.value += 1;
  }

  void ifUpdateInt1({bool update = true}) {
    if (update == true) {
      int1 += 1; // updates int1, will rebuild the rx related widget
    } else {
      int1.touch(); // `touch()` to activate rx automatic aspect, will also rebuild the rx related widget.
    }
  }

  Future<void> futureInt1() async {
    await Future.delayed(const Duration(seconds: 1));
    int1 += 1;
  }

  void updateNone() {
    publish('updateNone');
  }

  int get tick1 => _tick1.value;
  int get tick2 => _tick2.value;
  int get tick3 => _tick3;

  set tick1(int value) {
    _tick1.value = value;
    // publish('tick1'); // _tick1 is a rx variable, will publish automatically
  }

  set tick2(int value) {
    _tick2.value = value;
    // publish('tick2'); // _tick2 is a rx variable, will publish automatically
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
      // publish('tick1'); // _tick1 is a rx variable, will publish automatically
      if (_tick1.value % 2 == 0) {
        _tick2++;
        // publish('tick2'); // _tick2 is a rx variable, will publish automatically
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
MyModel getMyModel(BuildContext context) => Pub.getModel<MyModel>();

Subscriber<MyModel> subMyModel(CreatorFn<MyModel> create,
    {Key key, Object aspects}) {
  // return aspects.subModel<MyModel>(create, key: key);
  return Subscriber<MyModel>(key: key, aspects: aspects, create: create);
}

extension MyModelExtT<T> on T {
  Subscriber<MyModel> subMyModel(CreatorFn<MyModel> create, {Key key}) {
    return Subscriber<MyModel>(key: key, aspects: this, create: create);
  }
}
