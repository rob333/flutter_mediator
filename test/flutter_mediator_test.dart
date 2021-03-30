import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mediator/mediator.dart';

void main() {
  test('test RxInt operator+', () {
    final pub = Pub();
    var a = RxInt.withPub(1, pub);

    expect(a.value, 1);
    final b = a + 1;
    expect(a.value, 1);
    expect(b.value, 2);
    a++;
    expect(a.value, 2);
    ++a;
    expect(a.value, 3);
    a = a + 1;
    expect(a.value, 4);
    a += 1;
    expect(a.value, 5);
  });

  test('test RxInt operator-', () {
    final pub = Pub();
    var a = RxInt.withPub(5, pub);

    expect(a.value, 5);
    final b = a - 1;
    expect(a.value, 5);
    expect(b.value, 4);
    a--;
    expect(a.value, 4);
    --a;
    expect(a.value, 3);
    a = a - 1;
    expect(a.value, 2);
    a -= 1;
    expect(a.value, 1);
  });

  test('test rx aspects', () {
    final a = 5.rx;
    a.addRxAspects('aspect1');
    expect(a.rxAspects, ['aspect1']);

    a.addRxAspects(['aspect2', 'aspect3']);
    expect(a.rxAspects, ['aspect1', 'aspect2', 'aspect3']);

    a.removeRxAspects(['aspect1', 'aspect2']);
    expect(a.rxAspects, ['aspect3']);

    a.clearRxAspects();
    expect(a.rxAspects.isEmpty, true);

    a.addRxAspects([1, 2, 3]);
    expect(a.rxAspects, [1, 2, 3]);

    a.retainRxAspects([2, 3]);
    expect(a.rxAspects, [2, 3]);

    a.retainRxAspects(3);
    expect(a.rxAspects, [3]);

    a.removeRxAspects(3);
    expect(a.rxAspects.isEmpty, true);

    // mix rx aspect
    a.addRxAspects(['aspect1', 1, 2, 3, 'aspect2']);
    expect(a.rxAspects, ['aspect1', 1, 2, 3, 'aspect2']);
  });

  test('test rx_impl numToString', () {
    const len = 2000;
    final coll = <String>{};
    int count = 0;

    for (final int i in Iterable.generate(len)) {
      final tag = numToString128(i);
      coll.add(tag);
      // print('$tag, $count, ${coll.length}');
      expect(coll.length, count + 1);
      count++;
    }
  });

  test('benchmark rx++ operation', () {
    const n = 10000000;
    const msec = 5 * 1000;
    // ignore: unused_local_variable
    var cnt = 0;
    // ignore: unused_local_variable
    final pub = Pub();
    var rxi = RxInt.withPub(0, pub);

    var i = 0;
    var mark = 0;
    var start = DateTime.now().microsecondsSinceEpoch;
    for (i = 0; i < n; i++) {
      cnt++;
      mark = DateTime.now().microsecondsSinceEpoch - start;
      if (mark >= msec) {
        break;
      }
    }
    print('i++: ${1.0 * i / mark} ops/msec, $i ops of $mark msec');

    i = 0;
    start = DateTime.now().microsecondsSinceEpoch;
    for (i = 0; i < n; i++) {
      rxi.value++;
      mark = DateTime.now().microsecondsSinceEpoch - start;
      if (mark >= msec) {
        break;
      }
    }
    print('rxi.value++: ${1.0 * i / mark} ops/msec, $i ops of $mark msec');

    rxi.value = 0;
    i = 0;
    start = DateTime.now().microsecondsSinceEpoch;
    for (i = 0; i < n; i++) {
      rxi++;
      mark = DateTime.now().microsecondsSinceEpoch - start;
      if (mark >= msec) {
        break;
      }
    }
    print('rxi++: ${1.0 * i / mark} ops/msec, $i ops of $mark msec');

    rxi.value = 0;
    i = 0;
    start = DateTime.now().microsecondsSinceEpoch;
    for (i = 0; i < n; i++) {
      rxi += 1;
      mark = DateTime.now().microsecondsSinceEpoch - start;
      if (mark >= msec) {
        break;
      }
    }
    print('rxi+=: ${1.0 * i / mark} ops/msec, $i ops of $mark msec');
  });
}
