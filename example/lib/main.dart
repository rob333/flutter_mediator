import 'package:flutter/material.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mediator/mediator.dart';

import 'models/list_model.dart';
import 'models/my_model.dart';
import 'models/setting_model.dart';
import 'pages/info_page.dart';
import 'widgets/bottom_navigation_controller.dart';
import 'widgets/widget_extension.dart';

const double Width = 150;

void main() {
  runApp(
    MultiHost.create3(
      MyModel(updateMs: 1000), // model that extends Pub
      ListModel(updateMs: 500), // model that extends Pub
      Setting(),
      child: MyApp(),
    ),
    // MultiHost.create( // Generic form
    //   [
    //     Host<MyModel>(model: MyModel(updateMs: 1000)),
    //     Host<ListModel>(model: ListModel(updateMs: 500)),
    //     Host<Setting>(model: Setting()),
    //   ],
    //   child: MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Mediator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomNavigationWidget(
        pages: navPages,
        bottomNavItems: bottomNavItems,
        selectedColor: Colors.amber[800]!,
        backgroundColor: Colors.black54.withOpacity(0.5),
        selectedIndex: 0,
      ),
      // add flutter_i18n support
      // localizationsDelegates: [
      //   FlutterI18nDelegate(
      //     translationLoader: FileTranslationLoader(
      //       // forcedLocale: ,
      //       // useCountryCode: true,
      //       // fallbackFile: 'en',
      //       basePath: 'assets/flutter_i18n',
      //       decodeStrategies: [JsonDecodeStrategy()],
      //     ),
      //     missingTranslationHandler: (key, locale) {
      //       print(
      //           '--- Missing Key: $key, languageCode: ${locale.languageCode}');
      //     },
      //   ),
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
    );
  }
}

Widget buttonPage() {
  return Row(
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          allSubscriber(),
          Pub.sub<MyModel>('int1AndStr1'),
          //int1AndStr1Subscriber(),
          fooSubscriber(),
          barSubscriber(),
          // inline subscriber
          'bar'.subModel<MyModel>((_, model) => Text('Bar is ${model.bar}')),
          starSubscriber(),
          str1Subscriber(),
          int1Subscriber(),
          chainReactSubscriber(),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          fooController(),
          barController(),
          bothController(),
          allController(),
          str1Controller(),
          int1Controller(),
          futureController(),
          noController(),
          tick1(),
          tick2(),
          tick3(),
        ],
      ),
    ],
  );
}

Widget cardPage() {
  //* Original form:
  // return Subscriber<ListModel>(
  //   aspects: ListEnum.ListUpdate,
  //   create: (context, model) {
  //* Extension form:
  // return ListEnum.ListUpdate.subListModel((context, model) {
  return ListEnum.ListUpdate.subModel<ListModel>((context, model) {
    final data = model.data;
    return GridView.builder(
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              (MediaQuery.of(context).orientation == Orientation.portrait)
                  ? 5
                  : 10),
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          color: item.color,
          child: GridTile(
            footer: Text(item.units.toString()),
            child: Text(item.item),
          ).padding(const EdgeInsets.all(7.0)),
        );
      },
    );

    //* List View
    // return ListView.builder(
    //   itemCount: data.length,
    //   itemBuilder: (context, index) {
    //     final item = data[index];
    //     return ListTile(
    //       title: Text(item.item),
    //       subtitle: Text(item.units.toString()),
    //     ).background(item.color);
    //   },
    // );
  });
}

//* Subscriber all aspects of the model
//* Get the frame aspects with `model.frameAspects`
Widget allSubscriber() {
  return null.subModel<MyModel>(
    (context, model) {
      final aspects = model.frameAspects;
      final str = aspects.isEmpty ? '' : '$aspects received';
      return Text(
        str,
        softWrap: true,
        textAlign: TextAlign.center,
      );
    },
  ).sizeBox(width: Width, height: 30);
}

//* Subscribe two aspects
Widget int1AndStr1Subscriber() {
  return
      // ['int1', 'star'].subModel<MyModel>(
      //* Rx automatic aspect form:
      rxSub<MyModel>(
    (context, model) => Text(
      'Int1 is ${model.int1} and Str1 is ${model.str1}',
      softWrap: true,
      textAlign: TextAlign.center,
    ),
  );
}

//* Subscribe in the original form.
Widget fooSubscriber() {
  return Subscriber<MyModel>(
    aspects: 'foo',
    create: (context, model) {
      print('foo build');
      return Text('Foo is ${model.foo}');
    },
  );
}

//* Subscriber in simple form.
Widget barSubscriber() {
  return 'bar'.subModel<MyModel>((context, model) {
    print('bar build');
    return Text('bar is ${model.bar}');
  });
}

//* Subscriber with user extension.
Widget starSubscriber() {
  return 'star'.subMyModel((context, model) {
    print('star build');
    return Text('Star is ${model.star}');
  });
}

//* Subscriber in simple form.
Widget str1Subscriber() {
  return 'str1'.subModel<MyModel>((context, model) {
    print('str1 build');
    return Text('Str1 is ${model.str1}');
  });
}

//* Subscriber in the rx automatic aspect extension form.
Widget int1Subscriber() {
  //* Original form:
  // return Subscriber<MyModel>(
  //   aspects: 'int1',
  //   create:
  //* Extension form:
  // return 'int1'.subMyModel(
  // return 'int1'.subModel<MyModel>(
  //* Automatic aspect form:
  // return rxSub<MyModel>((_, model) => Text('Int1 is ${model.int1}'));
  //* Automatic aspect extension form:
  return (context, model) {
    print('int1 build');
    return Text('Int1 is ${model.int1}');
  }.rxSub<MyModel>();
}

//* Future function for chainReactSubscriber
int httpResCounter = 0;
Future<int> _futureHttpTask() async {
  await Future.delayed(const Duration(milliseconds: 0));
  return ++httpResCounter;
}

//* Chain subscribe binding myModel.str1 with aspect 'chainStr1'.
Widget chainReactSubscriber() {
  return 'chainStr1'.subModel<MyModel>((context, model) {
    return FutureBuilder(
      future: _futureHttpTask(),
      initialData: httpResCounter,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = Text('str1 chain counter: $httpResCounter');
        } else {
          child = Text('str1 init counter: $httpResCounter');
        }
        return Center(child: child);
      },
    );
  });
}

//* Controller example
Widget fooController() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Update foo'),
      onPressed: () => model.foo++,
    ),
  );
}

//* Controller example, using fat arrow expression
Widget barController() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Update bar'),
      onPressed: () => model.bar++,
    ),
  );
}

//* Controller example, update two variables.
Widget bothController() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Update both'),
      onPressed: () => model.increaseBoth(),
    ),
  );
}

//* Controller example, update all variables.
Widget allController() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Update all'),
      onPressed: () => model.increaseAll(),
    ),
  );
}

Widget str1Controller() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Update Str1'),
      onPressed: () => model.updateStr1(),
    ),
  );
}

Widget int1Controller() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Update Int1'),
      onPressed: () => model.updateInt1(),
    ),
  );
}

Widget futureController() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Future Int1:1sec'),
      onPressed: () => model.futureInt1(),
    ),
  );
}

Widget noController() {
  return Controller<MyModel>(
    create: (context, model) => RaisedButton(
      child: const Text('Update none'),
      onPressed: () => model.updateNone(),
    ),
  );
}

final _ColorRegistry tick1r = _ColorRegistry();
final _ColorRegistry tick2r = _ColorRegistry();
final _ColorRegistry tick3r = _ColorRegistry();

//* rxSub tick1 with timer update
Widget tick1() {
  // return 'tick1'.subMyModel(
  // return 'tick1'.subModel<MyModel>(
  return rxSub<MyModel>(
    (context, model) {
      // print('tick1 build');
      return _ColoredBox(
        color: tick1r.nextColor(),
        child: Text('tick1 is ${model.tick1}'),
      );
    },
  ).padding(const EdgeInsets.all(5.0)).sizeBox(width: Width, height: 60);
}

//* Subscribe tick2 with timer update
Widget tick2() {
  return 'tick2'
      .subModel<MyModel>(
        (context, model) {
          // print('tick2 build');
          return _ColoredBox(
            color: tick2r.nextColor(),
            child: Text('tick2 is ${model.tick2}'),
          );
        },
      )
      .padding(const EdgeInsets.all(5.0))
      .sizeBox(width: Width, height: 60);
}

//* Subscribe tick3 with timer update
Widget tick3() {
  return 'tick3'
      .subModel<MyModel>(
        (context, model) {
          // print('tick3 build');
          return _ColoredBox(
            color: tick3r.nextColor(),
            child: Text('tick3 is ${model.tick3}'),
          );
        },
      )
      .padding(const EdgeInsets.all(5.0))
      .sizeBox(width: Width, height: 60);
}

class _ColorRegistry {
  final List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.lightGreen,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  int _idx = 0;

  Color nextColor() {
    if (_idx >= colors.length) {
      _idx = 0;
    }
    return colors[_idx++];
  }
}

class _ColoredBox extends StatelessWidget {
  const _ColoredBox({Key? key, required this.color, required this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: color,
      child: child,
    );
  }
}

//* Comment out Tick1 class.
// class Tick1 extends StatelessWidget {
//   final _ColorRegistry r = _ColorRegistry();
//   @override
//   Widget build(BuildContext context) {
//     return
//         // 'tick1'.subMyModel(
//         rxSub<MyModel>(
//       (context, model) {
//         // print('tick1 build');
//         return _ColoredBox(
//           color: r.nextColor(),
//           child: Text('tick1 is ${model.tick1}'),
//         );
//       },
//     ).padding(const EdgeInsets.all(5.0)).sizeBox(width: Width, height: 60);
//   }
// }

final bottomNavItems = [
  const BottomNavigationBarItem(
    label: 'Buttons',
    icon: Icon(Icons.lightbulb_outline),
    activeIcon: Icon(Icons.library_books),
    // backgroundColor: ,
  ),
  const BottomNavigationBarItem(
    label: 'ListView',
    icon: Icon(Icons.new_releases),
    activeIcon: Icon(Icons.payment),
    // backgroundColor: ,
  ),
  const BottomNavigationBarItem(
    label: 'Info',
    icon: Icon(Icons.info_outline),
    activeIcon: Icon(Icons.inbox),
    // backgroundColor: ,
  ),
];
final navPages = [buttonPage(), cardPage(), infoPage()];
