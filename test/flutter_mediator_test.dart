import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mediator/mediator.dart';

void main() {
  test('test RxInt operator+', () {
    var a = 1.rx..pub = Pub();

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
    var a = 5.rx..pub = Pub();

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
}
