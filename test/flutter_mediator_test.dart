import 'package:flutter/material.dart';
import 'package:flutter_mediator/mediator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example_global_mode/test/touch_cnt.dart';

void main() {
  testWidgets('Flutter Mediator Counter increments smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const TouchCntApp(),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsOneWidget);
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
