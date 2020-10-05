import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mediator/mediator.dart';

//* aspect enum
enum ListEnum {
  ListUpdate,
}

//* Helper function of ListModel
ListModel getListModel(BuildContext context) {
  return Host.getInheritOfModel<ListModel>(context);
}

Subscriber<ListModel> subListModel(CreaterOfSubscriber<ListModel> create,
    {Key key, Object aspects}) {
  // return aspects.subModel<ListModel>(create, key: key);
  return Subscriber<ListModel>(key: key, aspects: aspects, create: create);
}

extension ListModelHelperT<T> on T {
  Subscriber<ListModel> subListModel(CreaterOfSubscriber<ListModel> create,
      {Key key}) {
    return Subscriber<ListModel>(key: key, aspects: this, create: create);
  }
}

// extension ListModelHelper on ListEnum {
//   Subscriber<ListModel> subListModel({Key key, @required CreaterOfSubscriber<ListModel> create}) {
//     return Subscriber<ListModel>(key: key, aspects: this, create: create);
//   }
// }

// extension ListListModelHelper on List<ListEnum> {
//   Subscriber<ListModel> subListModel({Key key, @required CreaterOfSubscriber<ListModel> create}) {
//     return Subscriber<ListModel>(key: key, aspects: this, create: create);
//   }
// }

//* List item
class ListItem {
  ListItem([
    this.item,
    this.units,
    this.color,
  ]);

  String item;
  int units;
  Color color;
}

//* model class
class ListModel extends Publisher {
  ListModel({this.updateMs}) : assert(updateMs > 0) {
    resetTimer();
  }

  // `.rx` make the var automatically rebuild the widget when updated
  final /*List<ListItem>*/ data = <ListItem>[].rx;
  final int updateMs;
  Timer updateTimer;

  void updateListItem() {
    final units = Random().nextInt(MaxUnits) + 1;
    final itemIdx = Random().nextInt(itemNames.length);
    final itemName = itemNames[itemIdx];
    final color = itemColors[Random().nextInt(itemColors.length)];
    if (data.length >= MaxItems) data.clear();

    data.add(ListItem(itemName, units, color)); // automatically update widgets
  }

  int getTotalUnits() {
    int sum = 0;
    for (int i = 0; i < data.length; i++) {
      sum += data[i].units;
    }
    return sum;
  }

  void resetTimer() {
    stopTimer();
    updateTimer = Timer.periodic(Duration(milliseconds: updateMs), (timer) {
      updateListItem();
    });
  }

  void stopTimer() {
    updateTimer?.cancel();
  }
}

//* item data
const int MaxItems = 35;
const int MaxUnits = 100;
const List<String> itemNames = [
  'Pencil',
  'Binder',
  'Pen',
  'Desk',
  'Pen Set',
];
const List<Color> itemColors = [
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

// List<ListItem> itemDatas = [
//   ListItem('Pencil', 95),
//   ListItem('Binder', 50),
//   ListItem('Pencil', 36),
//   ListItem('Pen', 28),
//   ListItem('Pencil', 56),
//   ListItem('Binder', 60),
//   ListItem('Pencil', 75),
//   ListItem('Pencil', 90),
//   ListItem('Pencil', 32),
//   ListItem('Binder', 60),
//   ListItem('Pencil', 90),
//   ListItem('Binder', 29),
//   ListItem('Binder', 81),
//   ListItem('Pencil', 35),
//   ListItem('Desk', 2),
//   ListItem('Pen Set', 16),
//   ListItem('Binder', 28),
//   ListItem('Pen', 64),
//   ListItem('Pen', 15),
//   ListItem('Pen Set', 96),
//   ListItem('Pencil', 67),
//   ListItem('Pen Set', 74),
//   ListItem('Binder', 46),
//   ListItem('Binder', 87),
//   ListItem('Binder', 4),
//   ListItem('Binder', 7),
//   ListItem('Pen Set', 50),
//   ListItem('Pencil', 66),
//   ListItem('Pen', 96),
//   ListItem('Pencil', 53),
//   ListItem('Binder', 80),
//   ListItem('Desk', 5),
// ];
