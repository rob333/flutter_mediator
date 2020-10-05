# Flutter Mediator

[![Pub](https://img.shields.io/pub/v/flutter_mediator.svg)](https://pub.dev/packages/flutter_mediator)

Flutter mediator is a MVC state management package base on InheritedModel with automatic aspect management to make them simpler, easier, and intuitive to use.

<p align="center"><img src="https://raw.githubusercontent.com/rob333/flutter_mediator/main/doc/images/main.gif"></p>

## Features

- **_Easy and simple to use_** - automatically make things work by only a few steps
- **_Efficiency and Performance_** - use InheritedModel as the underlying layer to make the app quick response
- **_Lightweight_** - small package size
- **_Flexible_** - provide both automatic and manual observation
- **_Intuitive_** - three main classes: **_`Publisher`, `Subscriber`, `Host`_**
  <br /> &emsp; **_`Publisher`_** - publish aspects
  <br /> &emsp; **_`Subscriber`_** - subscribe aspects
  <br /> &emsp; **_`Host`_** - dispatch aspects

### Flutter Widget of the Week: InheritedModel explained

&emsp; InheritedModel provides an aspect parameter to its descendants to indicate which fields they care about to determine whether that widget needs to rebuild. InheritedModel can help you rebuild its descendants only when necessary.

<p align="center">
<a href="https://www.youtube.com/watch?feature=player_embedded&v=ml5uefGgkaA
" target="_blank"><img src="https://img.youtube.com/vi/ml5uefGgkaA/0.jpg" 
alt="Flutter Widget of the Week: InheritedModel Explained" /></a></p>

# Setting up

Add the following dependency to pubspec.yaml of your flutter project:

```yaml
dependencies:
  flutter_mediator: "^1.0.0+3"
```

Import flutter_mediator in files that will be used:

```dart
import 'package:flutter_mediator/mediator.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.dev/docs).

<br />

# Getting Started Quick Steps

### **_`Model`_**, **_`View`_**, **_`Controller`_**, **_`Host`_**:

### **_`Model`_**:

&emsp; 1-1. Extend the model from **_`Publisher`_**
<br />
&emsp; 1-2. Declare rx variables with **_`.rx`_**, which will automatically rebuild the aspect-related-widget when updated.
<br />
&emsp; 1-3. Implement the update methods.

&emsp; For example,

```dart
/// MyModel.dart

class MyModel extends Publisher {
  /// `.rx` make the var automatically rebuild the aspect-related-widget when updated
  var int1 =  0.rx;

  void updateInt1() {
    /// since int1 is a rx variable,
    /// it will automatically rebuild the aspect-realted-widget when updated
    int1 +=  1;
  }
```

### **_`Subscribe the View`_**:

2. **_Subscribe the widget with one or multiple aspects._**

   - Subscribe one aspect:
     <br /> **_`aspect`_**`.subModel`**_`<Model>`_**`((context, model) {/*create method*/})`
   - Subscribe multiple aspects: (place aspects in a list)
     <br /> **_`[a1, a2]`_**`.subModel`**_`<Model>`_**`((context, model) {/*create method*/})`
   - Broadcast to all aspects of the model: (`null` aspect to broadcast)
     <br /> **_`null`_**`.subModel`**_`<Model>`_**`((context, model) {/*create method*/})`

   Place the subscriber in the widget tree then any rx variables inside the create method will automatically rebuild the aspect-related-widget when updated. _(triggered by getter and setter)_
   <br />

   For example, subscribe the widget with aspect of String **_`'int1'`_** of class **_`<MyModel>`_**

- simple form - create the subscriber directly

```dart
'int1'.subModel<MyModel>((context, model) => Text('${model.int1}')),
```

- class form - wrap the subscriber in a class

```dart
class Int1Subscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 'int1'.subModel<MyModel>((context, model) {
      /// Since model.int1 is a rx variable,
      /// it will automatically rebuild the aspect-related-widget when updated.
      /// In this example, the aspect is 'int1' of <MyModel>.
      return Text('Int1 is ${model.int1}');
    });
  }
}
```

### **_`Controller`_**:

3. Place the controller in the widget tree.
   <br /> For example, get the model of class **_`<MyModel>`_** and execute it's update method within a RaisedButton.

```dart
RaisedButton(
  child: const Text('Update Int1'),
  onPressed: () => context.getModel<MyModel>().updateInt1(),
);
```

### **_`Host`_**:

4. Place **_host_** at the top level of the widget tree.

```dart
void  main() {
  runApp(
    MultiHost.create2(
      MyModel(updateMs:  1000), // model extends from Publisher
      ListModel(updateMs:  500),// model extends from Publisher
      child:  MyApp(),
    ),
  /// MultiHost.create1 to MultiHost.create9 are provided by the package.
  );
}
```

### **_`Works automatically!`_**

5. Then whenever rx variables updates, the aspect-related-widget will rebuild automatically!

<br /> These steps can help you in most situations. The following details explain the package one step further.

<br />

# Example

You can find the example in the [example](https://github.com/rob333/flutter_mediator/tree/main/example/lib) folder.
<br /> Try it once, you will see it's simple and easy to use.

<br />

# Detail

1.  [**Single model**](#1-single-model) - host
2.  [**Multiple models**](#2-multiple-models) - host
3.  [**Automatically update the widget** with rx variable](#3-automatically-update-the-widget) - Publisher
4.  [**Access the underlying value directly** of rx variable](#4-access-the-underlying-value-directly) - Publisher
5.  [**Update the value by call style** of rx variable](#5-update-the-value-by-call-style) - Publisher
6.  [**Manually publish an aspect** of the model](#6-manually-publish-an-aspect) - Publisher
7.  [**Manually publish multiple aspects** of the model](#7-manually-publish-multiple-aspects) - Publisher
8.  [**Manually publish all aspects - broadcasting** of the model](#8-manually-publish-all-aspects---broadcasting) - Publisher
9.  [**Future publish** of the model](#9-future-publish) - Publisher
10. [**Rebuild only once per frame** for the same aspect](#10-rebuild-only-once-per-frame) - Publisher
11. [**Writing model helper**](#11-writing-model-helper) - Publisher
12. [**Get the model**](#12-get-the-model) - Subscriber
13. [**Subscribe an aspect** of the model](#13-subscribe-an-aspect) - Subscriber
14. [**Subscribe multiple aspects** of the model](#14-subscribe-multiple-aspects) - Subscriber
15. [**Subscribe all aspects** of the model](#15-subscribe-all-aspects) - Subscriber
16. [**Subscribe with enum aspects** of the model](#16-subscribe-with-enum-aspects) - Subscriber
17. [**Manage rx aspects - Chain react aspects**](#17-manage-rx-aspects---Chain-react-aspects) - advance topic
18. [**Implement custom rx class**](#18-implement-custom-rx-class) - advance topic
19. [**Aspect type**](#19-aspect-type) - terminology

<br />

## 1. Single model

```dart
void main() {
  runApp(
    Host(
      model: AppModel(), // model extends from Publisher
      child: MyApp(),
    ),
  );
}
```

&emsp; [back to detail](#detail)

<br />

## 2. Multiple models

**_`MultiHost.create1`_** to **_`MultiHost.create9`_** are provided by the package.
<br /> You can add more `MultiHost.createN` methods, see [multi_host.dart](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/multi_host.dart) for example.

```dart
void main() {
  runApp(
    MultiHost.create2(
      MyModel(updateMs: 1000),  // model extends from Publisher
      ListModel(updateMs: 500), // model extends from Publisher
      child:  MyApp(),
    ),
  );
}
```

&emsp; [back to detail](#detail)

<br />

## 3. Automatically update the widget

**_`.rx`_** wraps the variable into a rx variable, which will automatically rebuild the aspect-related-widget when updated

#### rx int:

```dart
class MyModel extends Publisher {
/// `.rx` make the var automatically update the aspect-related-widget
var int1 = 0.rx;

void  updateInt1() {
  int1 += 1; // automatically update the aspect-related-widget
}
```

#### rx list:

```dart
class ListModel extends Publisher {
  /// `.rx` make the var automatically update the aspect-related-widget
  final data =  <ListItem>[].rx;

  void updateListItem() {
    // get new item data...
    final newItem = ListItem(itemName, units, color);
    data.add(newItem); // automatically update the aspect-related-widget
  }
```

rx variable of type `int`, `double`, `num`, `string`, `bool`, `list`, `map`, `set` are provided by the package.
<br /> See also _[RxInt class](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/rx/rx_num.dart#L421)_,
[RxList class](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/rx/rx_iterable/rx_list.dart#L5),
[RxList.add](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/rx/rx_iterable/rx_list.dart#L35)

&emsp; [back to detail](#detail)

<br />

## 4. Access the underlying value directly

Access the underlying value directly by `.value`.

```dart
/// MyModel.dart

var int1 = 0.rx;
void updateInt1() {
  // int1 += 1;
  /// is the same as
  int1.value += 1; // automatically update the aspect-related-widget
}
```

&emsp; [back to detail](#detail)

<br />

## 5. Update the value by call style

```dart
/// MyModel.dart

var _foo = 1.rx;
set foo(int value) {
  _foo(value); // update rx variable by call() style
  /// is the same as
  // _foo = value;
  /// is the same as
  // _foo.value = value;
}
```

&emsp; [back to detail](#detail)

<br />

## 6. Manually publish an aspect

Use `publish()` method of class `Publisher` to manually publish an aspect.

```dart
/// MyModel.dart

int manuallyInt = 0;
void manuallyPublishDemo(int value) {
  manuallyInt = value;
  publish('manuallyInt'); // manually publish aspect of 'manuallyInt'
}
```

&emsp; [back to detail](#detail)

<br />

## 7. Manually publish multiple aspects

Place aspects in a list to publish multiple aspects.

```dart
/// MyModel.dart

int _foo = 0;
int _bar = 0;
void increaseBoth() {
  _foo += 1;
  _bar += 1;
  publish(['foo', 'bar']); // manually publish multiple aspects in a list
}
```

&emsp; [back to detail](#detail)

<br />

## 8. Manually publish all aspects - broadcasting

Publish null value to publish all aspects of the model.

```dart
/// MyModel.dart

void increaseAll() {
  //...
  publish(); // manually publish all aspects of the model
}
```

&emsp; [back to detail](#detail)

<br />

## 9. Future publish

Use rx variables within an async method, for example,

```dart
/// MyModel.dart

int int1 = 0.rx;
Future<void> futureInt1() async {
  await Future.delayed(const Duration(seconds: 1));
  int1 += 1; // int1 is an rx variable, it'll automatically update the aspect-related-widget when updated
}
```

&emsp; [back to detail](#detail)

<br />

## 10. Rebuild only once per frame

InheritedModel uses `Set` to accumulate aspects thus the same aspect only causes the related widget to rebuild once for the same aspect.
<br /> The following code only causes the aspect-related-widget to rebuild once.

```dart
/// MyModel.dart

int int1 = 0.rx;
void incermentInt1() async {
  int1 += 1; // int1 is an rx variable, it'll automatically update the aspect-related-widget when updated
  publish('int1'); // manually publish 'int1'
  publish('int1'); // manually publish 'int1', again
  // only cause the aspected-related-widget to rebuild once per frame
}
```

&emsp; [back to detail](#detail)

<br />

## 11. Writing model helper

You can write model helpers to simplified the typing, for example,

```dart
/// Helper function of MyModel
MyModel getMyModel(BuildContext context) {
  return Host.getInheritOfModel<MyModel>(context);
}

Subscriber<MyModel> subMyModel(CreaterOfSubscriber<MyModel> create,
    {Key key, Object aspects}) {
  return Subscriber<MyModel>(key: key, aspects: aspects, create: create);
}

extension MyModelHelperT<T> on T {
  Subscriber<MyModel> subMyModel(CreaterOfSubscriber<MyModel> create,
      {Key key}) {
    return Subscriber<MyModel>(key: key, aspects: this, create: create);
  }
}
```

```dart
/// Helper function of ListModel
ListModel getListModel(BuildContext context) {
  return Host.getInheritOfModel<ListModel>(context);
}

Subscriber<ListModel> subListModel(CreaterOfSubscriber<ListModel> create,
    {Key key, Object aspects}) {
  return Subscriber<ListModel>(key: key, aspects: aspects, create: create);
}

extension ListModelHelperT<T> on T {
  Subscriber<ListModel> subListModel(CreaterOfSubscriber<ListModel> create,
      {Key key}) {
    return Subscriber<ListModel>(key: key, aspects: this, create: create);
  }
}
```

_See also [mediator_helper.dart](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/mediator_helper.dart) for package helper._

&emsp; [back to detail](#detail)

<br />

## 12. Get the model

To get the model, for example, getting `MyModel`,

- original form

```dart
final model = Host.getInheritOfModel<MyModel>(context);
```

- package helper of context extension

```dart
final model = context.getModel<MyModel>();
```

- model helper on your own

```dart
final model = getMyModel(context);
```

#### **Get current triggered frame aspects of the model**. See also [AllSubscriber@main.dart](https://github.com/rob333/flutter_mediator/blob/main/example/lib/main.dart#L167).

```dart
final model = context.getModel<MyModel>();
final aspects = model.frameAspect;
```

&emsp; [back to detail](#detail)

<br />

## 13. Subscribe an aspect

For example, subscribe to a `String` aspect **_`'int1'`_** of class **_`<MyModel>`_**.

- original form within a class

```dart
class Int1Subscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Subscriber<MyModel>(
      aspects: 'int1',
      create: (context, model) {
        return Text('Int1 is ${model.int1}');
      },
    );
  }
}
```

- with helper

```dart
class Int1Subscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return 'int1'.subMyModel((_, m) => Text('${m.int1}')); // simple form
    // return 'int1'.subMyModel(     // with model helper on your own
    return 'int1'.subModel<MyModel>( // with package helper
      (context, model) {
        return Text('Int1 is ${model.int1}');
      },
    );
  }
}
```

- simple form

```dart
'int1'.subModel<MyModel>((context, model) => Text('Int1 is ${model.int1}')),
```

&emsp; [back to detail](#detail)

<br />

## 14. Subscribe multiple aspects

Place aspects in a list to subscribe multiple aspects.

- original form within a class

```dart
class TwoSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Subscriber<MyModel>(
      aspects: ['int1', 'star'],
      create: (context, model) {
        return Text(
          'Int1 is ${model.int1} and Star is ${model.star}',
          softWrap: true,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
```

- with helper

```dart
class TwoSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ['int1', 'star'].subMyModel(     // with model helper on your own
    return ['int1', 'star'].subModel<MyModel>( // with package helper
      (context, model) {
        return Text(
          'Int1 is ${model.int1} and Star is ${model.star}',
          softWrap: true,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
```

- simple form

```dart
['int1', 'star'].subModel<MyModel>(
  (context, model) => Text(
    'Int1 is ${model.int1} and Star is ${model.star}',
    softWrap: true,
    textAlign: TextAlign.center,
  ),
),
```

&emsp; [back to detail](#detail)

<br />

## 15. Subscribe all aspects

Provide no aspects parameter, or use null as aspect to subscribe to all aspects.
<br /> See also [AllSubscriber@main.dart](https://github.com/rob333/flutter_mediator/blob/main/example/lib/main.dart#L167).

- original form within a class

```dart
class AllSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Subscriber<MyModel>(
      // aspects: , // no aspects parameter means subscribe to all aspects
      create: (context, model) {
        final aspects = model.frameAspect;
        final str = aspects.isEmpty ? '' : '$aspects received';
        return Text(str, softWrap: true, textAlign: TextAlign.center);
      },
    );
  }
}
```

- with helper

```dart
class AllSubscriber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return null.subMyModel(     // with model helper on your own
    return null.subModel<MyModel>( // with package helper
      (context, model) {
        final aspects = model.frameAspect;
        final str = aspects.isEmpty ? '' : '$aspects received';
        return Text(str, softWrap: true, textAlign: TextAlign.center);
      },
    );
  }
}
```

- simple form

```dart
null.subModel<MyModel>(
  (context, model) {
    final aspects = model.frameAspect;
    final str = aspects.isEmpty ? '' : '$aspects received';
    return Text(str, softWrap: true, textAlign: TextAlign.center);
  },
),

```

&emsp; [back to detail](#detail)

<br />

## 16. Subscribe with enum aspects

You can use `enum` as aspect, for example, first, define the enum.

```dart
/// ListModel.dart
enum ListEnum {
  ListUpdate,
}
```

Then everything is the same as `String` aspect, just to replace the `String` with `enum`.
<br /> See also [ListItemView@main.dart](https://github.com/rob333/flutter_mediator/blob/main/example/lib/main.dart#L96).

- original form within a class

```dart
class ListItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Subscriber<ListModel>(
      aspects: ListEnum.ListUpdate,
      create: (context, model) {
      //...
    });
  }
}
```

- with helper

```dart
class ListItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return  ListEnum.ListUpdate.subListModel((context, model) { // with model helper on your own
    return ListEnum.ListUpdate.subModel<ListModel>((context, model) { // with package helper
      //...
    });
  }
}
```

- simple form

```dart
ListEnum.ListUpdate.subModel<ListModel>((context, model) { ... }),
```

&emsp; [back to detail](#detail)

<br />

## 17. Manage rx aspects - Chain react aspects

### **Chain react aspects:**

Supposed you need to rebuild a widget whenever a model variable is updated, but it has nothing to do with the variable. Then you can use chain react aspects.
<br /> For example, to rebuild a widget whenever **_`str1`_** of class **_`<MyModel>`_** is updated, and chained by the aspect **`'chainStr1'`**.

```dart
/// MyModel.dart
final str1 = 's'.rx..addRxAspects('chainStr1'); // to chain react aspects
```

```dart
/// main.dart
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
```

Then whenever **_`str1`_** of class **_`<MyModel>`_** updates, the widget rebuild automatically.

### **Manage rx aspects:**

- Add aspects to the rx variable:

  - add an aspect: `rxVar.addRxAspects('chained-aspect')`
  - add multiple aspects: `rxVar.addRxAspects(['chained-as1', 'chained-as2'])`
  - add aspects from another rx variable: `rxVar.addRxAspects(otherRxVar)`
  - broadcast to the model: `rxVar.addRxAspects()`

- Remove aspects from the rx variable:

  - remove an aspect: `rxVar.removeRxAspects('chained-aspect')`
  - remove multiple aspects: `rxVar.removeRxAspects(['chained-as1', 'chained-as2'])`
  - remove aspects from another rx variable: `rxVar.removeRxAspects(otherRxVar)`
  - don't broadcast to the model: `rxVar.removeRxAspects()`

- Retain aspects in the rx variable:

  - retain an aspect: `rxVar.retainRxAspects('chained-aspect')`
  - retain multiple aspects: `rxVar.retainRxAspects(['chained-as1', 'chained-as2'])`
  - retain aspects from another rx variable: `rxVar.retainRxAspects(otherRxVar)`

- Clear all rx aspects:

  - `rxVar.clearRxAspects()`

&emsp; [back to detail](#detail)

<br />

## 18. Implement custom rx class

If you need to write your own rx class, see [custom_rx_class.dart](https://github.com/rob333/flutter_mediator/blob/main/example/lib/custom_rx_class.dart) for example.

&emsp; [back to detail](#detail)

<br />

## 19. Aspect type

- Widget aspects - aspects that the widget subscribes.
- Frame aspects - aspects that this UI frame will update.
- Registered aspects - aspects that the model has registered.
- Rx aspects - aspects that the rx variable is attached. Once the rx variable gets updated, it will publish these aspects to the host.

&emsp; [back to detail](#detail)

<br />

<!-- &nbsp;&nbsp; -->

# Changelog

Please see the [Changelog](https://github.com/rob333/flutter_mediator/blob/main/CHANGELOG.md) page.

<br />

# License

[MIT](https://github.com/rob333/flutter_mediator/blob/main/LICENSE)
