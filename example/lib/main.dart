import 'package:flutter/material.dart';
import 'package:flutter_mediator/mediator.dart';

import 'models/list_model.dart';
import 'models/my_model.dart';
import 'widgets/BottomNavigationController.dart';
import 'widgets/widget_extension.dart';

const double Width = 150;

void main() {
  runApp(
    MultiHost.create2(
      MyModel(updateMs: 1000), // model that extends Publisher
      ListModel(updateMs: 500), // model that extends Publisher
      child: MyApp(),
    ),

    /// single host: the original form, or use MultiHost.create1
    // Host(
    //   model: MyModel(updateMs: 1000),
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
        selectedColor: Colors.amber[800],
        backgroundColor: Colors.black54.withOpacity(0.5),
        selectedIndex: 0,
      ),
    );
  }
}

Widget buttonPage() {
  return Row(
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AllSubscriber(),
          /* inline subscriber of two aspects */
          ['int1', 'star'].subModel<MyModel>(
            (context, model) => Text(
              'Int1 is ${model.int1} and Star is ${model.star}',
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          FooSubscriber(),
          BarSubscriber(),
          /* inline subscriber of an aspect */
          'bar'.subModel<MyModel>((_, model) => Text('Bar is ${model.bar}')),
          StarSubscriber(),
          Str1Subscriber(),
          Int1Subscriber(),
          ChainReactSubscriber(),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FooUpdater(),
          BarUpdater(),
          BothUpdater(),
          AllUpdater(),
          Str1Updater(),
          Int1Updater(),
          FutureUpdater(),
          NoUpdater(),
          Tick1(),
          Tick2(),
          Tick3(),
        ],
      ),
    ],
  );
}

Widget cardPage() {
  return ListItemView();
}

class ListItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// original form
    // return Subscriber<ListModel>(
    //   aspects: ListEnum.ListUpdate,
    //   create: (context, model) {

    /// with helper
    // return ListEnum.ListUpdate.subModel<ListModel>((context, model) {
    return ListEnum.ListUpdate.subListModel((context, model) {
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
}

Widget infoPage() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('MyModel:'),
      'tick1'.subMyModel((context, myModel) {
        return Text('tick1 is ${myModel.tick1}');
      }),

      const SizedBox(height: 30),

      // ListEnum.ListUpdate.subListModel((context, listModel) {
      ListEnum.ListUpdate.subModel<ListModel>((context, listModel) {
        return Column(
          children: [
            const Text('ListModel:'),
            Text('sales:${listModel.data.length}'),
            Text('Total units:${listModel.getTotalUnits()}'),
          ],
        );
      }),
    ],
  ).center();
}

class AllSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Subscriber<MyModel>(
    // return null.subMyModel(
    return null.subModel<MyModel>(
      (context, model) {
        final aspects = model.frameAspect;
        final str = aspects.isEmpty ? '' : '$aspects received';
        return Text(
          str,
          softWrap: true,
          textAlign: TextAlign.center,
        );
      },
    ).sizeBox(width: Width, height: 30);
  }
}

class FooSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Subscriber<MyModel>(
      aspects: 'foo',
      create: (context, model) {
        print('foo build');
        return Text('Foo is ${model.foo}');
      },
    );
  }
}

class BarSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 'bar'.subModel<MyModel>(
      (context, model) {
        print('bar build');
        return Text('Bar is ${model.bar}');
      },
    );
  }
}

class StarSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 'star'.subModel<MyModel>(
      (context, model) {
        print('star build');
        return Text('Star is ${model.star}');
      },
    );
  }
}

class Str1Subscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 'str1'.subMyModel(
      (context, model) {
        print('str1 build');
        return Text('Str1 is ${model.str1}');
      },
    );
  }
}

class Int1Subscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return 'int1'.subMyModel((_, m) => Text('${m.int1}')); // simple form
    /// original form:
    // return Subscriber<MyModel>(
    //   aspects: 'int1',
    //   create:
    return 'int1'.subModel<MyModel>(
      (context, model) {
        print('int1 build');
        return Text('Int1 is ${model.int1}');
      },
    );
  }
}

int httpResCounter = 0;

class ChainReactSubscriber extends StatelessWidget {
  Future<int> _futureHttpTask() async {
    await Future.delayed(const Duration(milliseconds: 0));
    return ++httpResCounter;
  }

  @override
  Widget build(BuildContext context) {
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
}

class FooUpdater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = context.getModel<MyModel>();
    return RaisedButton(
      child: const Text('Update foo'),
      onPressed: () => model.foo++,
    );
  }
}

class BarUpdater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = getMyModel(context);
    return RaisedButton(
        child: const Text('Update bar'), onPressed: () => model.bar++);
  }
}

class BothUpdater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = getMyModel(context);
    return const Text('Update both').raisedButton(
      onPressed: () => model.increaseBoth(),
    );
  }
}

class AllUpdater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = getMyModel(context);
    return RaisedButton(
      child: const Text('Update all'),
      onPressed: () => model.increaseAll(),
    );
  }
}

class Str1Updater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = getMyModel(context);
    return RaisedButton(
      child: const Text('Update Str1'),
      onPressed: () => model.updateStr1(),
    );
  }
}

class Int1Updater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = context.getModel<MyModel>();
    return RaisedButton(
      child: const Text('Update Int1'),
      onPressed: () => model.updateInt1(),
    );
  }
}

class FutureUpdater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: const Text('Future Int1:1sec'),
      onPressed: () => context.getModel<MyModel>().futureInt1(),
    );
  }
}

class NoUpdater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = getMyModel(context);
    return RaisedButton(
      child: const Text('Update none'),
      onPressed: () => model.updateNone(),
    );
  }
}

class Tick1 extends StatelessWidget {
  final _ColorRegistry r = _ColorRegistry();

  @override
  Widget build(BuildContext context) {
    return 'tick1'
        .subMyModel(
          (context, model) {
            // print('tick1 build');
            return _ColoredBox(
              color: r.nextColor(),
              child: Text('tick1 is ${model.tick1}'),
            );
          },
        )
        .padding(const EdgeInsets.all(5.0))
        .sizeBox(width: Width, height: 60);
  }
}

class Tick2 extends StatelessWidget {
  final _ColorRegistry r = _ColorRegistry();

  @override
  Widget build(BuildContext context) {
    return 'tick2'
        .subMyModel(
          (context, model) {
            // print('tick2 build');
            return _ColoredBox(
              color: r.nextColor(),
              child: Text('tick2 is ${model.tick2}'),
            );
          },
        )
        .padding(const EdgeInsets.all(5.0))
        .sizeBox(width: Width, height: 60);
  }
}

class Tick3 extends StatelessWidget {
  final _ColorRegistry r = _ColorRegistry();

  @override
  Widget build(BuildContext context) {
    return 'tick3'
        .subMyModel(
          (context, model) {
            // print('tick3 build');
            return _ColoredBox(
              color: r.nextColor(),
              child: Text('tick3 is ${model.tick3}'),
            );
          },
        )
        .padding(const EdgeInsets.all(5.0))
        .sizeBox(width: Width, height: 60);
  }
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
  const _ColoredBox({Key key, this.color, this.child}) : super(key: key);

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
