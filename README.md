# Flutter Mediator

<table cellpadding="0" border="0">
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator">Flutter Mediator</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator"><img src="https://img.shields.io/pub/v/flutter_mediator.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator/actions"><img src="https://github.com/rob333/flutter_mediator/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Global Mode + Model Mode
    </td>
  </tr>
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator_lite">Lite</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator_lite"><img src="https://img.shields.io/pub/v/flutter_mediator_lite.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator_lite.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_lite/actions"><img src="https://github.com/rob333/flutter_mediator_lite/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Global Mode only
    </td>
  </tr>
  <tr>
    <td align="right">
    <a href="https://github.com/rob333/flutter_mediator_persistence">Persistence</a>
    </td>
    <td>
    <a href="https://pub.dev/packages/flutter_mediator_persistence"><img src="https://img.shields.io/pub/v/flutter_mediator_persistence.svg" alt="pub.dev"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_persistence/blob/main/LICENSE"><img src="https://img.shields.io/github/license/rob333/flutter_mediator_persistence.svg" alt="License"></a>
    </td>
    <td>
    <a href="https://github.com/rob333/flutter_mediator_persistence/actions"><img src="https://github.com/rob333/flutter_mediator_persistence/workflows/Build/badge.svg" alt="Build Status"></a>
    </td>
    <td>
    Lite + Persistence
    </td>
  </tr>
  <tr>
    <td align="right">
    Example
    </td>
    <td colspan="4">
    <a href="https://github.com/rob333/Flutter-logins-to-a-REST-server-with-i18n-theming-persistence-and-state-management">Logins to a REST server with i18n, theming, persistence and state management.</a>
    </td>
  </tr>
</table>

<br>

<!--
Flutter Mediator:
[![Pub](https://img.shields.io/pub/v/flutter_mediator.svg)](https://pub.dev/packages/flutter_mediator)
[![MIT License](https://img.shields.io/github/license/rob333/flutter_mediator.svg)](https://github.com/rob333/flutter_mediator/blob/main/LICENSE)
[![Build](https://github.com/rob333/flutter_mediator/workflows/Build/badge.svg)](https://github.com/rob333/flutter_mediator/actions)
&nbsp; &nbsp;
Lite:
[![Pub](https://img.shields.io/pub/v/flutter_mediator_lite.svg)](https://pub.dev/packages/flutter_mediator_lite)
[![MIT License](https://img.shields.io/github/license/rob333/flutter_mediator_lite.svg)](https://github.com/rob333/flutter_mediator_lite/blob/main/LICENSE)
[![Build](https://github.com/rob333/flutter_mediator_lite/workflows/Build/badge.svg)](https://github.com/rob333/flutter_mediator_lite/actions)
-->

Flutter mediator is a state management package base on the [InheritedModel][] with automatic aspect management to make it simpler and easier to use and rebuild widgets only when necessary.

<table border="0" align="center">
  <tr>
    <td>
      <img src="https://raw.githubusercontent.com/rob333/flutter_mediator/main/doc/images/main.gif">
    </td>
    <td>
      <img src="https://raw.githubusercontent.com/rob333/flutter_mediator/main/doc/images/global_mode.gif">
    </td>
  </tr>
</table>

<br>
<hr>

## Table of Contents

- [Global Mode](#global-mode)
  - [Steps](#steps)
    - [Case 1: Int](#case-1-int)
    - [Case 2: List](#case-2-list)
    - [Case 3: Locale setting with Persistence by SharedPreferences](#case-3-locale-setting-with-persistence-by-sharedpreferences)
    - [Case 4: Scrolling effect](#case-4-scrolling-effect)
  - [Recap](#recap)
  - [Global Get](#global-get)
    - [Case 1: By `Type`](#case-1-by-type)
    - [Case 2: By `tag`](#case-2-by-tag)
  - [Global Broadcast](#global-broadcast)
  - [Versions](#versions)
  - [Example: Logins to a REST server](#example-logins-to-a-rest-server)
- [Model Mode](#model-mode)
  - [Three main classes: **_`Pub`, `Subscriber`, `Host`_**](#three-main-classes-pub-subscriber-host)
  - [Flow chart](#flow-chart)
  - [Flutter Widget of the Week: InheritedModel explained](#flutter-widget-of-the-week-inheritedmodel-explained)
  - [Key contepts](#key-contepts)
    - [**Subscribe and Publish**](#subscribe-and-publish)
    - [**Rx Variable**](#rx-variable)
    - [**Widget Aspects**](#widget-aspects)
    - [**Rx Related Widget**](#rx-related-widget)
    - [**Rx Automatic Aspect**](#rx-automatic-aspect)
    - [**View Map**](#view-map)
  - [Getting Started Quick Steps](#getting-started-quick-steps)
    - [1. **_Model:_**](#1-model)
    - [2. **_Host:_**](#2-host)
    - [3. **_View: Subscribe widgets_**](#3-view-subscribe-widgets)
    - [4. **_Controller:_**](#4-controller)
  - [Access the underlying value of rx variables](#access-the-underlying-value-of-rx-variables)
  - [Visual Studio Code snippets](#visual-studio-code-snippets)
  - [View Map - one step further of dependency injection](#view-map---one-step-further-of-dependency-injection)
    - [Original View](#original-view)
    - [After using the View Map](#after-using-the-view-map)
    - [Here's how to use View Map.](#heres-how-to-use-view-map)
    - [Summing up](#summing-up)
  - [Use Case - explain how the package works](#use-case---explain-how-the-package-works)
    - [Case 1: use rx automatic aspect](#case-1-use-rx-automatic-aspect)
    - [Case 2: with specific aspect](#case-2-with-specific-aspect)
    - [Case 3: manual publish aspect](#case-3-manual-publish-aspect)
  - [Use Case - i18n with View Map](#use-case---i18n-with-view-map)

<hr>

## Setting up

Add the following dependency to pubspec.yaml of your flutter project:

```yaml
dependencies:
  flutter_mediator: "^2.1.6"
```

Import flutter_mediator in files that will be used:

```dart
import 'package:flutter_mediator/mediator.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.dev/docs).

&emsp; [Table of Contents]

# Global Mode

As of v2.1.0 introduces a `Global Mode` to support a super easy way to use the state management.

## Steps

1. Declare the watched variable with `globalWatch`.
   <br>**Suggest to put the watched variables into a file [var.dart][example_global_mode/lib/var.dart] and then import it.**

2. Create the host with `globalHost`, or `MultiHost.create` if you want to use Model Mode together, at the top of the widget tree.

3. Create a consume widget with `globalConsume` or `watchedVar.consume` to register the watched variable to the host to rebuild it when updating.

4. Make an update to the watched variable, by `watchedVar.value` or `watchedVar.ob.updateMethod(...)`.

&emsp; [Table of Contents]

### Case 1: Int

[example_global_mode/lib/main.dart][]

Step 1: Declare variable in [var.dart][example_global_mode/lib/var.dart].

```dart
//* Step1: Declare the watched variable with `globalWatch` in the var.dart.
//* And then import it in the file.
final touchCount = globalWatch(0);
```

Step 2: Initialize the persistent watched variable and create the `Host`.

```dart
Future<void> main() async {
  //* Initialize the persistent watched variables
  //* whose value is stored by the SharedPreferences.
  await initVars();

  runApp(
    //* Step2: Create the host with `globalHost`
    //* at the top of the widget tree.
    globalHost(
      child: MyApp(),
    ),
  );
}
```

Step 3: Create a consume widget.

```dart
Scaffold(
  appBar: AppBar(title: const Text('Global Mode:Int Demo')),
  body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('You have pushed the button this many times:'),
      //* Step3: Create a consume widget with
      //* `globalConsume` or `watchedVar.consume` to register the
      //* watched variable to the host to rebuild it when updating.
      globalConsume(
        () => Text(
          '${touchCount.value}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
   // ...
```

Step 4: Implement update function.

```dart
FloatingActionButton(
  //* Stet4: Make an update to the watched variable.
  onPressed: () => touchCount.value++,
  tooltip: 'Increment',
  child: const Icon(Icons.add),
  heroTag: null,
),
```

&emsp; [Table of Contents]

### Case 2: List

[example_global_mode/lib/pages/list_page.dart][]

Step 1: Declare variable in [var.dart][example_global_mode/lib/var.dart].

```dart
//* Step1: Declare the watched variable with `globalWatch` in the var.dart.
//* And then import it in the file.
final data = globalWatch(<ListItem>[]);
```

Step 3: Create consume widget.

```dart
return Scaffold(
  appBar: AppBar(title: const Text('Global Mode:List Demo')),
  //* Step3: Create a consume widget with
  //* `globalConsume` or `watchedVar.consume` to register the
  //* watched variable to the host to rebuild it when updating.
  body: globalConsume(
    () => GridView.builder(
      itemCount: data.value.length,

    // ...
```

Step 4: Implement update function.

```dart
void updateListItem() {
  // ...

  //* Step4: Make an update to the watched variable.
  //* watchedVar.ob = watchedVar.notify() and then return the underlying object
  data.ob.add(ListItem(itemName, units, color));
}
```

&emsp; [Table of Contents]

### Case 3: Locale setting with Persistence by SharedPreferences

> Or use [Flutter Mediator Persistence][persistence] for built in persistence support.
> <br>
> Please see [Flutter Mediator Persistence: use case 3][persistence_use_case3] for details.

[example_global_mode/lib/pages/locale_page.dart][]

Step 1-1: Declare variable in [var.dart][example_global_mode/lib/var.dart].

```dart
//* Declare a global scope SharedPreferences.
late SharedPreferences prefs;

//* Step1B: Declare the persistent watched variable with `late Rx<Type>`
//* And then import it in the file.
const DefaultLocale = 'en';
late Rx<String> locale; // local_page.dart

/// Initialize the persistent watched variables
/// whose value is stored by the SharedPreferences.
Future<void> initVars() async {
  // To make sure SharedPreferences works.
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  locale = globalWatch(prefs.getString('locale') ?? DefaultLocale);
}
```

Step 1-2: Initialize the persistent watched variables in [main.dart][example_global_mode/lib/main.dart].

```dart
Future<void> main() async {
  //* Step1-2: Initialize the persistent watched variables
  //* whose value is stored by the SharedPreferences.
  await initVars();

  runApp(
    // ...
  );
}
```

Step 1-3: Initialize the locale in [main.dart][example_global_mode/lib/main.dart].

```dart
//* Initialize the locale with the persistent value.
localizationsDelegates: [
  FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      forcedLocale: Locale(locale.value),
      fallbackFile: DefaultLocale,
      // ...
    ),
    // ...
  ),
],
```

Step 1-4: Add assets in [pubspec.yaml][] and prepare locale files in the [folder][flutter_i18n]

```yaml
flutter:
  # ...
  assets:
    - assets/images/
    - assets/flutter_i18n/
```

Step 3: Create consume widget

```dart
return SizedBox(
  child: Row(
    children: [
      //* Step3: Create a consume widget with
      //* `globalConsume` or `watchedVar.consume` to register the
      //* watched variable to the host to rebuild it when updating.
      //* `watchedVar.consume()` is a helper function to
      //* `touch()` itself first and then `globalConsume`.
      locale.consume(() => Text('${'app.hello'.i18n(context)} ')),
      Text('$name, '),
      //* Or use the ci18n extension
      'app.thanks'.ci18n(context),
      // ...
    ],
  ),
);
```

Step 4: Implement update function in [var.dart][example_global_mode/lib/var.dart].

```dart
Future<void> changeLocale(BuildContext context, String countryCode) async {
  if (countryCode != locale.value) {
    final loc = Locale(countryCode);
    await FlutterI18n.refresh(context, loc);
    //* Step4: Make an update to the watched variable.
    locale.value = countryCode; // will rebuild the registered widget

    await prefs.setString('locale', countryCode);
  }
}
```

&emsp; [Table of Contents]

### Case 4: Scrolling effect

[example_global_mode/lib/pages/scroll_page.dart][]

Step 1: Declare variable in [var.dart][example_global_mode/lib/var.dart].

```dart
//* Step1: Declare the watched variable with `globalWatch` in the var.dart.
//* And then import it in the file.
final opacityValue = globalWatch(0.0);
```

Step 3: Create consume widget.

```dart
class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Step3: Create a consume widget with
    //* `globalConsume` or `watchedVar.consume` to register the
    //* watched variable to the host to rebuild it when updating.
    return globalConsume(
      () => Container(
        color: Colors.black.withOpacity(opacityValue.value),
        // ...
      ),
    );
  }
}
```

Step 4: Add an offset change listener.

```dart
class _ScrollPageState extends State<ScrollPage> {
  // ...

  @override
  void initState() {
    _scrollController.addListener(() {
      //* Step4: Make an update to the watched variable.
      opacityValue.value =
          (_scrollController.offset / 350).clamp(0, 1).toDouble();
    });
    super.initState();
  }
```

&emsp; [Table of Contents]

## Recap

- At step 1, `globalWatch(variable)` creates a watched variable from the variable.

- At step 2, `MultiHost` works with both `Global Mode` and `Model Mode`.

- At step 3, create a consume widget and register it to the host to rebuild it when updating,
  <br> use **`globalConsume(() => widget)`** **if the value of the watched variable is used inside the consume widget**;
  <br>or use **`watchedVar.consume(() => widget)`** to `touch()` the watched variable itself first and then `globalConsume(() => widget)`.

- At step 4, update to the `watchedVar.value` will notify the host to rebuild; or the underlying object would be a class, then use `watchedVar.ob.updateMethod(...)` to notify the host to rebuild. <br>**`watchedVar.ob = watchedVar.notify() and then return the underlying object`.**

&emsp; [Table of Contents]

## Global Get

> Note: Suggest to put the watched variables into a file [var.dart][example_global_mode/lib/var.dart] and then import it.

`globalGet<T>({Object? tag})` to retrieve the watched variable from another file.

- With `globalWatch(variable)`, the watched variable will be retrieved by the `Type` of the variable, i.e. retrieve by `globalGet<Type>()`.

- With `globalWatch(variable, tag: object)`, the watched variable will be retrieved by the tag, i.e. retrieve by `globalGet(tag: object)`.

&emsp; [Table of Contents]

<br>

### Case 1: By `Type`

```dart
//* Step1: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0);
```

`lib/pages/locale_page.dart`
[example_global_mode/lib/pages/locale_page.dart][]

```dart
class LocalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Get the watched variable by it's [Type] from `../main.dart`
    final mainInt = globalGet<int>();

    return Container(
      // ...
          const SizedBox(height: 25),
          //* `globalConsume` the watched variable from `../main.dart`
          globalConsume(
            () => Text(
              'You have pressed the button at the first page ${mainInt.value} times',
            ),
      // ...
```

&emsp; [Table of Contents]

### Case 2: By `tag`

```dart
//* Step1: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0, tag: 'tagCount');
```

`lib/pages/locale_page.dart`
[example_global_mode/lib/pages/locale_page.dart][]

```dart
class LocalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //* Get the watched variable by [tag] from `../main.dart`
    final mainInt = globalGet('tagCount');

    return Container(
      // ...
          const SizedBox(height: 25),
          //* `globalConsume` the watched variable from `../main.dart`
          globalConsume(
            () => Text(
              'You have pressed the button at the first page ${mainInt.value} times',
            ),
      // ...
```

<br>

### **Note**

- **Make sure the watched variable is initialized, only after the page is loaded.**

- **When using `Type` to retrieve the watched variable, only the first one of the `Type` is returned.**

&emsp; [Table of Contents]

## Global Broadcast

- `globalBroadcast()`, to broadcast to all the consume widgets.
- `globalConsumeAll(Widget Function() create, {Key? key})`, to create a consume widget which will be rebuilt whenever any watched variables changes are made.
- `globalFrameAspects`, a getter, to return the updated aspects of the Global Mode.
- `globalAllAspects`, a getter, to return all the aspects that has been registered to the Global Mode.

&emsp; [Table of Contents]

## Versions

- [Flutter Mediator][flutter_mediator]: Global Mode + Model Mode.
- [Lite][]: Global Mode only.
- [Persistence][]: Lite + built in persistence.

&emsp; [Table of Contents]

## Example: Logins to a REST server

A boilerplate example that logins to a REST server with i18n, theming, persistence and state management.

Please see the [login to a REST server example][loginrestexample] for details.

&emsp; [Table of Contents]

<br>

[table of contents]: #table-of-contents
[flutter_mediator]: https://github.com/rob333/flutter_mediator/
[lite]: https://github.com/rob333/flutter_mediator_lite/
[persistence]: https://github.com/rob333/flutter_mediator_persistence/
[persistence_use_case3]: https://github.com/rob333/flutter_mediator_persistence#case-3-locale-setting-with-built-in-persistence
[inheritedmodel]: https://api.flutter.dev/flutter/widgets/InheritedModel-class.html
[example_global_mode/lib/main.dart]: https://github.com/rob333/flutter_mediator/blob/main/example_global_mode/lib/main.dart
[example_global_mode/lib/var.dart]: https://github.com/rob333/flutter_mediator/blob/main/example_global_mode/lib/var.dart
[example_global_mode/lib/pages/list_page.dart]: https://github.com/rob333/flutter_mediator/blob/main/example_global_mode/lib/pages/list_page.dart
[example_global_mode/lib/pages/locale_page.dart]: https://github.com/rob333/flutter_mediator/blob/main/example_global_mode/lib/pages/locale_page.dart
[example_global_mode/lib/pages/scroll_page.dart]: https://github.com/rob333/flutter_mediator/blob/main/example_global_mode/lib/pages/scroll_page.dart
[loginrestexample]: https://github.com/rob333/Flutter-logins-to-a-REST-server-with-i18n-theming-persistence-and-state-management
[pubspec.yaml]: https://github.com/rob333/flutter_mediator/blob/main/example/pubspec.yaml
[flutter_i18n]: https://github.com/rob333/flutter_mediator/tree/main/example/assets/flutter_i18n

# Model Mode

### Three main classes: **_`Pub`, `Subscriber`, `Host`_**

- **_`Pub`_** : The base class of implementing a model, to **publish aspects**.
- **_`Subscriber`_** : The widget class that register to the host to **subscribe aspects**, being notified to rebuild when updating.
- **_`Host`_** : The InheritedModel widget, to place at the top of the widget tree, to **dispatch aspects**.

### Flow chart

<p align="center">
<div align="left">Initialization:</div>
  <img src="https://raw.githubusercontent.com/rob333/flutter_mediator/main/doc/images/Initialization.png">
</p>
<p align="center">
<div align="left">Updating:</div>
  <img src="https://raw.githubusercontent.com/rob333/flutter_mediator/main/doc/images/Updating.png">
</p>
<br>

### Flutter Widget of the Week: InheritedModel explained

InheritedModel provides an aspect parameter to its descendants to indicate which fields they care about to determine whether that widget needs to rebuild. InheritedModel can help you rebuild its descendants only when necessary.

<p align="center">
<a href="https://www.youtube.com/watch?feature=player_embedded&v=ml5uefGgkaA
" target="_blank"><img src="https://img.youtube.com/vi/ml5uefGgkaA/0.jpg" 
alt="Flutter Widget of the Week: InheritedModel Explained" /></a></p>

&emsp; [Table of Contents]

## Key contepts

#### **Subscribe and Publish**

A widget subscribes with aspects and will rebuild whenever a model controller publishs any of those aspects.

#### **Rx Variable**

The watched variable in the Global Mode.

A proxy object, by design pattern, proxy provides a surrogate or placeholder for another object to control access to it.
Variables in the model can turn into a proxy object by denoting **_`.rx`_**

#### **Widget Aspects**

Aspects denote what the widget is interested in. That widget will rebuild whenever any of those aspects is published.

#### **Rx Related Widget**

When subscribing a widget, any rx variables used inside the create method will automatically rebuild the widget when updating.

#### **Rx Automatic Aspect**

By using `rxSub`**_`<Model>`_** to subscribe a widget, the package will generate aspects for the widget automatically, **provides there is at least one rx variable used or use `model.rxVar.touch()` inside the create method** to activate rx automatic aspect. (and so this widget is a rx related widget)

#### **View Map**

<!-- same as View Map section-->

View map consists of two maps of create methods, `Subscriber` and `Controller`, that build upon **_rx automatic aspect_** and try to go one step further to make the UI view cleaner.

&emsp; [Table of Contents]

## Getting Started Quick Steps

**_Host_**, **_Model_**, **_View_**, **_Controller_**:

### 1. **_Model:_**

&emsp; 1-1. Implement the model by extending from **_`Pub`_**
<br>
&emsp; 1-2. Use **_`.rx`_** to turn the model variable into a rx variable which will automatically rebuild related widgets when updating.
<br>
&emsp; 1-3. Implement the controller method of that variable.

&emsp; For example,

```dart
/// my_model.dart
class MyModel extends Pub {
  /// `.rx` make the var automatically rebuild related widgets when updating.
  var int1 = 0.rx;

  void updateInt1() {
    /// `int1` is a rx variable which will automatically rebuild realted widgets when updating.
    int1 +=  1;
  }
}
```

&emsp; **Then, later, get the model by**

- `Host.model`**_`<Model>`_**`()`

> Note that you don't need `context` to get the model, this provides you the flexibility to do things anywhere.

### 2. **_Host:_**

Register the models to the **_`Host`_**, and place it at the top level of the widget tree.
<br>**`MultiHost.create1`** to **`MultiHost.create9`** are provided by the package, use it with the number of the amount of models.
<br> For example, register `2` models, **_`MyModel`_** and **_`ListModel`_**, to the host.

```dart
void main() {
  runApp(
    MultiHost.create2(
      MyModel(updateMs: 1000), // model extends from Pub
      ListModel(updateMs: 500),// model extends from Pub
      child: MyApp(),
    ),
  );
}
```

Or, use the generic form.

```dart
    MultiHost.create( // Generic form
      hosts: [
        Host<MyModel>(model: MyModel(updateMs: 1000)),
        Host<ListModel>(model: ListModel(updateMs: 500)),
      ],
      child: MyApp(),
    ),
```

### 3. **_View: Subscribe widgets_**

There are two ways to subscribe a widget:

- **Rx Automatic Aspect**: (_Recommend_)

  - The package will generate aspects for the widget automatically, **provides there is at least one rx variable used or use `model.rxVar.touch()` inside the create method** to activate rx automatic aspect. (and so this widget is a rx related widget)
    <br> `rxSub`**_`<Model>`_**`((context, model) {/*`**_`create method`_** `*/})`

- **With Specific Aspect**:

  - Subscribe an aspect:
    <br> **_`aspect`_**`.subModel`**_`<Model>`_**`((context, model) {/*`**_`create method`_** `*/})`
  - Subscribe multiple aspects: (Place aspects in a list)
    <br> **_`[a1, a2]`_**`.subModel`**_`<Model>`_**`((context, model) {/*`**_`create method`_** `*/})`
  - Broadcast to all aspects of the model: (Subscribe with `null` aspect to broadcast)
    <br> **_`null`_**`.subModel`**_`<Model>`_**`((context, model) {/*`**_`create method`_** `*/})`

Place that `Subscriber` in the widget tree then any rx variables used inside the create method will automatically rebuild related widgets when updating. _(triggered by getter and setter)_
<br>

For example, subscribes a widget with model class **_`<MyModel>`_**

- Case 1: Use rx automatic aspect.

```dart
rxSub<MyModel>((context, model) => Text('Int1 is ${model.int1}'))
```

- Case 2: With specific aspect **_`'int1'`_**.

```dart
'int1'.subModel<MyModel>((context, model) => Text('Int1 is ${model.int1}'))
```

<!-- same as detail: Touch the rx variable -->

- Case 3: When using rx automatic aspect, but the create method does not use any rx variables, then you can use `model.rxVar.touch()` which the widget depends on that `rxVar` to activate rx automatic aspect.
  <br> For example, when changing locale, the create method doesn't have to display the value of the locale, then you can use `model.locale.touch()` to activate rx automatic aspect.

```dart
rxSub<MyModel>((context, model) {
  model.locale.touch();
  final hello = 'app.hello'.i18n(context);
  return const Text('$hello');
})
```

### 4. **_Controller:_**

Place the controller in the widget tree.
<br> For example, to get the model class **_`<MyModel>`_** and execute its controller method within a `ElevatedButton`.

```dart
Controller<MyModel>(
  create: (context, model) => ElevatedButton(
    child: const Text('Update Int1'),
    onPressed: () => model.updateInt1(), // or simplely, `model.int1++`
  ),
)
```

Or implement a `controller function` of `MyModel.updateInt1()`, then place it in the widget tree.

```dart
Widget int1Controller() {
  return Controller<MyModel>(
    create: (context, model) => ElevatedButton(
      child: const Text('Update Int1'),
      onPressed: () => model.updateInt1(), // or simplely, `model.int1++`
    ),
  );
}
```

### **_Works automatically!_**

Then whenever the rx variable updates, the related widgets will rebuild automatically!

&emsp; [Table of Contents]

<!-- same as detail: Access the underlying value of rx variables -->

## Access the underlying value of rx variables

Sometimes, an operation of a rx variable can not be done, then you need to do that with the underlying value by denoting **`.value`** .
<br> For example,

```dart
/// my_model.dart
var int1 = 0.rx;   // turn int1 into a rx variable (i.e. a proxy object)
var str1 = 'A'.rx; // turn str1 into a rx variable (i.e. a proxy object)
void updateInt1() {
  // int1 *= 5; // can not do this (dart doesn't support operator*= to override)
  int1.value *= 5; // need to do that with the underlying value
  // str1 = 'B'; // can not do this
  str1.value = 'B'; // need to do that with the underlying value
}
```

&emsp; [Table of Contents]

## Visual Studio Code snippets

These are code snippets, for example, for visual studio code to easy using the package.
<br> To add these code snippets in visual studio code, press

`control+shift+p => Preferences: Configure user snippets => dart.json`
<br> Then add the content of [vscode_snippets.json](https://github.com/rob333/flutter_mediator/blob/main/example/lib/vscode_snippets.json) into the `dart.json`.

Now you can type these shortcuts for code templates to easy using the package:

- `mmodel` - **Generate a Model Boilerplate Code of Flutter Mediator**.
- `getmodel` - Get the Model of Flutter Mediator.
- `pubmodel` - Get the Model of Flutter Mediator, the same as `getmodel`.

&emsp; View Map shortcuts: (See View Map)

- `addsub` - Add a Creator to the Subscriber Map of the Model.
- `addcon` - Add a Creator to the Controller Map of the Model.
- `pubsub` - Create a Subscriber Widget from the Subscriber Map of the Model.
- `pubcon` - Create a Controller Widget from the Controller Map of the Model.

&emsp; Shortcuts:

- `controller` - Create a Flutter Mediator Controller Function.
- `subscriber` - Create a Flutter Mediator Subscriber Function with Aspect.
- `rxfun` - Create a Flutter Mediator Subscriber Function with RX Automatic Aspect.
- `submodel` - Create a Flutter Mediator Subscriber with Aspect.
- `rxsub` - Create a Flutter Mediator Subscriber with RX Automatic Aspect.

&emsp; [Table of Contents]

## View Map - one step further of dependency injection

<!-- same as key concept View Map -->

View map consists of two maps of create methods, `Subscriber` and `Controller`, which build upon **_rx automatic aspect_** and try to go one step further to make the UI view cleaner.

First, let's see what's the difference by an original view and after using the view map.

#### Original View

```dart
/// Original view
class LocalePanel extends StatelessWidget {
  const LocalePanel({Key key}) : super(key: key);

  Widget txt(BuildContext context, String name) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          rxSub<ListModel>(
            (context, model) {
              model.locale.touch(); // to activate rx automatic aspect
              final hello = 'app.hello'.i18n(context);
              return Text('$hello ');
            },
          ),
          Text('$name, '),
          rxSub<ListModel>(
            (context, model) {
              model.locale.touch(); // to activate rx automatic aspect
              final thanks = 'app.thanks'.i18n(context);
              return Text('$thanks.');
            },
          ),
        ],
      ),
    );
  }
/// ...
```

#### After using the View Map

```dart
/// After using the View Map
class LocalePanel extends StatelessWidget {
  const LocalePanel({Key key}) : super(key: key);

  Widget txt(BuildContext context, String name) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Pub.sub<ListModel>('hello'), // use `pubsub` shortcut for boilerplate
          Text('$name, '),
          Pub.sub<ListModel>('thanks'), // use `pubsub` shortcut for boilerplate
        ],
      ),
    );
  }
/// ...
```

Isn't it cleaner.

### Here's how to use View Map.

1. Add these code into the model and change `<Model>` to the class name of the model.
   > Use the code snippet shortcut, `mmodel`, to generate these boilerplate code.

```dart
/// some_model.dart
  void addSub(Object key, CreatorFn<Model> sub) => regSub<Model>(key, sub);
  void addCon(Object key, CreatorFn<Model> con) => regCon<Model>(key, con);

  @override
  void init() {
    // addSub('', (context, model) {
    //   return Text('foo is ${model.foo}');
    // });

    // addCon('', (context, model) {
    //   return ElevatedButton(child: const Text('Update foo'),
    //     onPressed: () => model.increaseFoo(),);
    // });

    super.init();
  }
```

2. Use the `addsub` or `addcon` shortcut to add create methods of `Subscriber` or `Controller` in the `init()` method.
   > `'hello'` and `'thanks'` are the keys to the map, later, you can use these keys to create corresponding widgets.

```dart
/// in the init() of some_model.dart
    // use `addsub` shortcut to generate boilerplate code
    addSub('hello', (context, model) {
      model.locale.touch(); // to activate rx automatic aspect
      final hello = 'app.hello'.i18n(context);
      return Text('$hello ');
    });

    // use `addsub` shortcut to generate boilerplate code
    addSub('thanks', (context, model) {
      model.locale.touch(); // to activate rx automatic aspect
      final thanks = 'app.thanks'.i18n(context);
      return Text('$thanks.');
    });
```

3. Then use the `pubsub` shortcut to place the `Subscriber` widget in the widget tree.
   > Change `<Model>` to the class name of the model.

```dart
/// in the widget tree
      child: Row(
        children: [
          Pub.sub<Model>('hello'), // use `pubsub` shortcut for boilerplate
          Text('$name, '),
          Pub.sub<Model>('thanks'),// use `pubsub` shortcut for boilerplate
        ],
      ),
```

<br>

**Now you just need to use these shortcuts, or commands, to do state management.**

- `mmodel` - Generate a Model Boilerplate Code.
- `addsub` - Add a Creator to the Subscriber Map of the Model.
- `addcon` - Add a Creator to the Controller Map of the Model.
- `pubsub` - Create a Subscriber Widget from the Subscriber Map of the Model.
- `pubcon` - Create a Controller Widget from the Controller Map of the Model.

Plus with,

- `.rx` - Turn model variables into rx variables, thus, you can use rx automatic aspect.
- `rxVar.touch()` - Used when the create method doesn't have to display the value of that rx variable, then you `touch()` that rx variable to activate rx automatic aspect.
- `getmodel` - Get the model. (Note that `context` is not needed to get the model.)

&emsp; [Table of Contents]

### Summing up

- **Subscriber**: Use at least one rx variable or `model.rxVar.touch()` which the widget depends on that `rxVar` to activate rx automatic aspect.

- **Controller**: To publish the aspect, it's automatically done with the rx variables, or publish the aspect manually.

> To custom a rx class please see [Detail: 21 implement a custom rx class](#21-implement-a-custom-rx-class).

&emsp; [Table of Contents]

## Use Case - explain how the package works

> This use case explains how the package works, you can skip it. There is an [use case for i18n with View Map](#use-case---i18n-with-view-map), which is much more straight forward to use.

First of all, implement the **`Model`** and place the **`Host`** at the top level of the widget tree,

```dart
/// my_model.dart
class MyModel extends Pub {
  var int1 = 0.rx; // turn int1 into a rx variable (i.e. a proxy object)
  var star = 0.rx; // turn str1 into a rx variable (i.e. a proxy object)
  var m = 0;       // ordinary variable

  /// controller function for case 1
  void ifUpdateInt1({bool update = true}) {
    if (update == true) {
      int1 += 1; // `int1` is a rx variable which will rebuild related widgets when updating.
    } else {
      int1.touch(); // `touch()` to activate rx automatic aspect which will also rebuild related widgets.
    }
  }

  /// controller function for case 2
  void increaseStar() => star++; // `star` is a rx variable which will rebuild related widgets when updating.

  /// controller function for case 3
  void increaseManual(Object aspect) {
    m++;
    publish(aspect); // `m` is an ordinary variable which needs to publish the aspect manually.
  }
}
```

```dart
/// main.dart
void main() {
  runApp(
    MultiHost.create1(
      MyModel(updateMs:  1000), // model extends from Pub
      child: MyApp(),
    ),
  );
}
```

#### Case 1: use rx automatic aspect

Implement the `Subscriber` and `Controller` functions, and place them in the widget tree.

```dart
/// main.dart
/// Subscriber function
Widget rxAAInt1Subscriber() {
  return rxSub<MyModel>((context, model) {
    return Text('int1: ${model.int1}');
  });
}
/// Controller function
Widget rxAAInt1Controller() {
  return Controller<MyModel>(
    create: (context, model) => ElevatedButton(
      child: const Text('ifInt1'),
      onPressed: () => model.ifUpdateInt1(),
    ),
  );
}
/// widget tree
Widget mainPage() {
  return Column(
    children: [
      rxAAInt1Subscriber(),
      rxAAInt1Controller(),
    ],
  );
}
```

&emsp; [Table of Contents]

#### Case 2: with specific aspect

Specific an aspect, for example, `'star'`, then implement the `Subscriber` and `Controller` functions for that aspect, and place them in the widget tree.

```dart
/// main.dart
/// Subscriber function
Widget starSubscriber() {
  return 'star'.subModel<MyModel>((context, model) {
    return Text('star: ${model.star}');
  });
}
/// Controller function
Widget starController() {
  return Controller<MyModel>(
    create: (context, model) => ElevatedButton(
      child: const Text('update star'),
      onPressed: () => increaseStar(), // or simplely model.star++,
    ),
  );
}
/// widget tree
Widget mainPage() {
  return Column(
    children: [
      starSubscriber(),
      starController(),
    ],
  );
}
```

&emsp; [Table of Contents]

#### Case 3: manual publish aspect

Specific an aspect, for example, `'manual'`, then implement the `Subscriber` and `Controller` functions for that aspect, and place them in the widget tree, and do `publish` the aspect in the controller function.

```dart
/// main.dart
/// Subscriber function
Widget manualSubscriber() {
  return 'manual'.subModel<MyModel>((context, model) {
    return Text('manual: ${model.manual}');
  });
}
/// Controller function
Widget manualController() {
  return Controller<MyModel>(
    create: (context, model) => ElevatedButton(
      child: const Text('update manual'),
      onPressed: () => increaseManual('manual'),
    ),
  );
}
/// widget tree
Widget mainPage() {
  return Column(
    children: [
      manualSubscriber(),
      manualController(),
    ],
  );
}
```

&emsp; [Table of Contents]

## Use Case - i18n with View Map

For example, to write an i18n app using flutter_i18n with View Map.

> These are all boilerplate code, you may just need to look at the lines with comments, that's where to put the code in.

1. Edit `pubspec.yaml` to use flutter_i18n and flutter_mediator.

```yaml
dependencies:
  flutter_i18n: ^0.22.3
  flutter_mediator: ^2.1.6

flutter:
  assets:
    - assets/flutter_i18n/
```

2. Create the i18n folder `asserts/flutter_i18n` and edit the locale files, [see folder](https://github.com/rob333/flutter_mediator/tree/main/example/assets/flutter_i18n).
   <br> For example, an [`en.json`](https://github.com/rob333/flutter_mediator/blob/main/example/assets/flutter_i18n/en.json) locale file.

```json
{
  "app": {
    "hello": "Hello",
    "thanks": "Thanks",
    "~": ""
  }
}
```

3. Create a folder `models` then new a file `setting_model.dart` in the folder and use `mmodel` shortcut to generate a model boilerplate code with the class name `Setting`.

4. Add an `i18n` extension to the `setting_model.dart`.

```dart
//* i18n extension
extension StringI18n on String {
  String i18n(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }
}
```

5. Add the `locale` variable and make it a rx variable along with the `changeLocale` function, then add create methods to the `Setting` model. (in the `init()` method)
   <br> Add the `SettingEnum` to represent the map keys of the view map.

```dart
/// setting_model.dart
enum SettingEnum {
  hello,
  thanks,
}

class Setting extends Pub {
  //* member variables
  var locale = 'en'.rx;

  //* controller function
  Future<void> changeLocale(BuildContext context, String countryCode) async {
    final loc = Locale(countryCode);
    await FlutterI18n.refresh(context, loc);
    locale.value = countryCode;
    // `locale` is a rx variable which will rebuild related widgets when updating.
  }

  //* View Map:
  // ...

  @override
  void init() {
    addSub(SettingEnum.hello, (context, model) { // SettingEnum.hello is the map key
      model.locale.touch(); // to activate rx automatic aspect
      final hello = 'app.hello'.i18n(context); // app.hello is the json field in the locale file
      return Text('$hello ');
    });

    addSub(SettingEnum.thanks, (context, model) { // SettingEnum.thanks is the map key
      model.locale.touch(); // to activate rx automatic aspect
      final thanks = 'app.thanks'.i18n(context); // app.thanks is the json field in the locale file
      return Text('$thanks.');
    });
    //...
```

6. Setup `main.dart`.
   <br> Import files, add `Setting` model to the host, i18n stuff and set `home` to `infoPage()`.

```dart
/// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mediator/mediator.dart';

import 'models/setting_model.dart';

void main() {
  runApp(
    MultiHost.create1(
      Setting(), // add `Setting` model to the host
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mediator Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // add flutter_i18n support, i18n stuff
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            decodeStrategies: [JsonDecodeStrategy()],
          ),
          missingTranslationHandler: (key, locale) {
            print('--- Missing Key: $key, languageCode: ${locale!.languageCode}');
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: infoPage(), // set `infoPage` as home page
    );
  }
}

```

7. Implement `infoPage()` with View Map.
   > These are boilerplate code, just look at the lines with comments, that's where to put the code in.

```dart
/// main.dart
Widget infoPage() {
  return Scaffold(
    body: Column(
      children: [
        SizedBox(height: 50),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              RadioGroup(),
              LocalePanel(),
            ],
          ),
        ),
      ],
    ),
  );
}

class LocalePanel extends StatelessWidget {
  const LocalePanel({Key key}) : super(key: key);

  Widget txt(String name) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Pub.sub<Setting>(SettingEnum.hello), // Use `pubsub` shortcut for boilerplate, SettingEnum.hello is the map key.
          Text('$name, '),
          Pub.sub<Setting>(SettingEnum.thanks), // Use `pubsub` shortcut for boilerplate, SettingEnum.thanks is the map key.
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [for (final name in names) txt(name)],
    );
  }
}

class RadioGroup extends StatefulWidget {
  const RadioGroup({
    Key key,
  }) : super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  final locales = ['en', 'fr', 'nl', 'de', 'it', 'zh', 'jp', 'kr']; // locale values
  final languages = [ // the language options to let the user to select, need to be corresponded with the locale values
    'English',
    'français',
    'Dutch',
    'Deutsch',
    'Italiano',
    '中文',
    '日本語',
    '한국어',
  ];

  Future<void> _handleRadioValueChange1(String? value) async {
    final model = Host.model<Setting>(); // use `getmodel` shortcut to get the model
    await model.changeLocale(context, value!); // change the locale
    setState(() {
      /// model.locale.value = value; // changed in model.changeLocale
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Host.model<Setting>(); // use `getmodel` shortcut to get the model
    final _radioValue1 = model.locale.value; // get the locale value back to maintain state

    Widget panel(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio(
            value: locales[index],
            groupValue: _radioValue1,
            onChanged: _handleRadioValueChange1,
          ),
          Text(
            languages[index],
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      );
    }

    return Container(
      width: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [for (var i = 0; i < locales.length; i++) panel(i)],
      ),
    );
  }
}


final names = [
  'Aarron',
  'Josh',
  'Ibraheem',
  'Rosemary',
  'Clement',
  'Kayleigh',
  'Elisa',
  'Pearl',
  'Aneesah',
  'Tom',
  'Jordana',
  'Taran',
  'Bethan',
  'Haydon',
  'Olivia-Mae',
  'Anam',
  'Kelsie',
  'Denise',
  'Jenson',
  'Piotr',
];
```

8. Work completed. Now you get an app with i18n support.

&emsp; [Table of Contents]

## Example

You can find the example in the [example/lib](https://github.com/rob333/flutter_mediator/tree/main/example/lib) folder.

<br>

> **These steps can help you in most situations. The following details explain the package one step further, you can skip it.**

# Details

1.  [**Single model**](#1-single-model) - host
2.  [**Multiple models**](#2-multiple-models) - host
3.  [**Automatically rebuild the widget whenever the rx variable updates**](#3-automatically-rebuild-the-widget-whenever-the-rx-variable-updates) - Pub
4.  [**Access the underlying value of rx variables**](#4-access-the-underlying-value-of-rx-variables) - Pub
5.  [**Update the rx variables by call style**](#5-update-the-rx-variables-by-call-style) - Pub
6.  [**Manually publish an aspect**](#6-manually-publish-an-aspect) - Pub
7.  [**Manually publish multiple aspects**](#7-manually-publish-multiple-aspects) - Pub
8.  [**Broadcast to the model**](#8-broadcast-to-the-model) - Pub
9.  [**Publish aspects of a rx variable**](#9-publish-aspects-of-a-rx-variable) - Pub
10. [**Future publish**](#10-future-publish) - Pub
11. [**Rebuild only once a frame** for the same aspect](#11-rebuild-only-once-a-frame) - Pub
12. [**Writing model extension**](#12-writing-model-extension) - Pub
13. [**Get the model**](#13-get-the-model) - Controller and Subscriber
14. [**Subscribe with rx automatic aspect** - rx automatic aspect](#14-subscribe-with-rx-automatic-aspect) - Subscriber
15. [**Touch the rx variable** - rx automatic aspect](#15-touch-the-rx-variable) - Subscriber
16. [**Subscribe an aspect** - specific aspect](#16-subscribe-an-aspect) - Subscriber
17. [**Subscribe multiple aspects** - specific aspect](#17-subscribe-multiple-aspects) - Subscriber
18. [**Subscribe all aspects** - specific aspect](#18-subscribe-all-aspects) - Subscriber
19. [**Subscribe with enum aspects** - specific aspect](#19-subscribe-with-enum-aspects) - Subscriber
20. [**Manage rx aspects - Chain react aspects**](#20-manage-rx-aspects---Chain-react-aspects) - advance topic
21. [**Implement a custom rx class**](#21-implement-a-custom-rx-class) - advance topic
22. [**Aspect type**](#22-aspect-type) - terminology

<br>

## 1. Single model

Register a model to the Host, and place it at the top level of the widget tree.

```dart
/// main.dart
void main() {
  runApp(
    Host(
      model: AppModel(), // model extends from Pub
      child: MyApp(),
    ),
  );
}
```

&emsp; [back to details][]

<br>

## 2. Multiple models

Register multiple models to the Host, and place it at the top level of the widget tree.
<br>**`MultiHost.create1`** to **`MultiHost.create9`** are provided by the package, use it with the number of the amount of models.

```dart
/// main.dart
void main() {
  runApp(
    MultiHost.create2(
      MyModel(updateMs: 1000),  // model extends from Pub
      ListModel(updateMs: 500), // model extends from Pub
      child: MyApp(),
    ),
  );
}
```

Or, use the generic form.

```dart
    MultiHost.create( // Generic form
      hosts: [
        Host<MyModel>(model: MyModel(updateMs: 1000)),
        Host<ListModel>(model: ListModel(updateMs: 500)),
      ],
      child: MyApp(),
    ),
```

&emsp; [back to details][]

<br>

## 3. Automatically rebuild the widget whenever the rx variable updates

Denoting **_`.rx`_** turns the variable of the model into a rx variable, a proxy object, which will automatically rebuild related widgets when updating. For Example,

#### rx int:

```dart
/// my_model.dart
class MyModel extends Pub {
/// `.rx` turns the var into a rx variable(i.e. a proxy object)
/// which will rebuild related widgets when updating.
var int1 = 0.rx;

void  updateInt1() {
  int1 += 1; // Automatically rebuild related widgets.
}
```

#### rx list:

```dart
/// list_model.dart
class ListModel extends Pub {
  /// `.rx` turn the var into a rx variable(i.e. a proxy object)
  /// which will rebuild related widgets when updating.
  final data =  <ListItem>[].rx;

  void updateListItem() {
    // get new item data...
    final newItem = ListItem(itemName, units, color);
    data.add(newItem); // Automatically rebuild related widgets.
  }
```

rx variable of type `int`, `double`, `num`, `string`, `bool`, `list`, `map`, `set` are provided by the package.
<br> See also _[RxInt class](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/rx/rx_num.dart#L421)_,
[RxList class](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/rx/rx_iterable/rx_list.dart#L5),
[RxList.add](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/rx/rx_iterable/rx_list.dart#L35)

&emsp; [back to details][]

<br>

<!-- same as Access the underlying value of rx variables -->

## 4. Access the underlying value of rx variables

- **`rxVar.value`** : Return the underlying value.
- **`rxVar.ob`** : Do a `rxVar.notify()` first to notify the host to rebuild then return the underlying object. Typically used with classes that aren't supported by the package.

For example,

```dart
/// my_model.dart
var int1 = 0.rx;   // turn int1 into a rx variable (i.e. a proxy object)
var str1 = 'A'.rx; // turn str1 into a rx variable (i.e. a proxy object)
void updateInt1() {
  // int1 *= 5; // can not do this (dart doesn't support operator*= to override)
  int1.value *= 5; // need to do that with the underlying value
  // str1 = 'B'; // can not do this
  str1.value = 'B'; // need to do that with the underlying value
}

final customClass = CustomClass();
final data = customClass.rx; // turn customClass into a rx variable (i.e. a proxy object)
void updateData() {
  data.ob.add(5);
}

```

&emsp; [back to details][]

<br>

## 5. Update the rx variables by call style

Dart provides a `call(T)` to override, you can use `rxVar(value)` to update the underlying value.

```dart
/// my_model.dart
var _foo = 1.rx;
set foo(int value) {
  _foo(value); // update the rx variable by call() style
  /// The same as:
  // _foo = value;
  /// The same as:
  // _foo.value = value;
}
```

&emsp; [back to details][]

<br>

## 6. Manually publish an aspect

Use the `publish()` method of the model to manually publish an aspect.

```dart
/// my_model.dart
int manuallyInt = 0;
void manuallyPublishDemo(int value) {
  manuallyInt = value;
  publish('manuallyInt'); // manually publish aspect of 'manuallyInt'
}
```

&emsp; [back to details][]

<br>

## 7. Manually publish multiple aspects

Place aspects in a list to publish multiple aspects.

```dart
/// my_model.dart
int _foo = 0;
int _bar = 0;
void increaseBoth() {
  _foo += 1;
  _bar += 1;
  publish(['foo', 'bar']); // manually publish multiple aspects
}
```

&emsp; [back to details][]

<br>

## 8. Broadcast to the model

Publish null value to broadcast to all aspects of the model.

```dart
/// my_model.dart
void increaseAll() {
  //...
  publish(); // broadcasting, publish all aspects of the model
}
```

&emsp; [back to details][]

<br>

## 9. Publish aspects of a rx variable

Publish a rx variable to publish the aspects that rx variable attached.

```dart
/// my_model.dart
var int1 = 0.rx;
void publishInt1Related() {
  //...
  publish(int1); // publish the aspects that int1 attached
}
```

&emsp; [back to details][]

<br>

## 10. Future publish

Use rx variables within an async method.

```dart
/// my_model.dart
int int1 = 0.rx;
Future<void> futureInt1() async {
  await Future.delayed(const Duration(seconds: 1));
  int1 += 1; // `int1` is a rx variable which will automatically rebuild related widgets when updating.
}
```

&emsp; [back to details][]

<br>

## 11. Rebuild only once a frame

By using `Set` to accumulate aspects, the same aspect only causes the related widget to rebuild only once.
<br> The following code only causes the related widget to rebuild once.

```dart
/// my_model.dart
int int1 = 0.rx;
void incermentInt1() async {
  int1 += 1; // `int1` is a rx variable which will automatically rebuild related widgets when updating.
  publish('int1'); // Manually publish 'int1'.
  publish('int1'); // Manually publish 'int1', again.
  // Only cause the related widgets to rebuild only once.
}
```

&emsp; [back to details][]

<br>

## 12. Writing model extension

You can write model extensions to simplified the typing. For example,

> Use shortcut `mmodel` will generate these extensions automatically.

```dart
/// MyModel extension
MyModel getMyModel(BuildContext context) => Host.model<MyModel>();

Subscriber<MyModel> subMyModel(CreatorFn<MyModel> create,
    {Key? key, Object? aspects}) {
  return Subscriber<MyModel>(key: key, aspects: aspects, create: create);
}

extension MyModelExtT<T> on T {
  Subscriber<MyModel> subMyModel(CreatorFn<MyModel> create,
      {Key? key}) {
    return Subscriber<MyModel>(key: key, aspects: this, create: create);
  }
}
```

```dart
/// ListModel extension
ListModel getListModel(BuildContext context) => Host.model<ListModel>();

Subscriber<ListModel> subListModel(CreatorFn<ListModel> create,
    {Key? key, Object? aspects}) {
  return Subscriber<ListModel>(key: key, aspects: aspects, create: create);
}

extension ListModelExtT<T> on T {
  Subscriber<ListModel> subListModel(CreatorFn<ListModel> create,
      {Key? key}) {
    return Subscriber<ListModel>(key: key, aspects: this, create: create);
  }
}
```

> _See also [extension.dart](https://github.com/rob333/flutter_mediator/blob/main/lib/mediator/extension.dart) for package extension._

&emsp; [back to details][]

<br>

## 13. Get the model

To get the model, for example, getting `MyModel`,

> Note that you don't need `context` to get the model, this provides you the flexibility to do things anywhere.

- original form

```dart
final model = Host.model<MyModel>();
```

- with user extension

```dart
final model = getMyModel();
```

#### **Get current triggered frame aspects of the model**. See also [allSubscriber@main.dart][].

```dart
final model = Host.model<MyModel>();
final aspects = model.frameAspects;
```

&emsp; [back to details][]

<br>

## 14. Subscribe with rx automatic aspect

By using `rxSub`**_`<Model>`_** to subscribe a widget, the package will generate aspects for the widget automatically, **provides there is at least one rx variable used or use `model.rxVar.touch()` inside the create method** to activate rx automatic aspect. (and so this widget is a rx related widget)
<br> For example,

```dart
/// my_model.dart
int tick1 = 0.rx;
```

```dart
/// main.dart
rxSub<MyModel>((context, model) {
  return Text('tick1 is ${model.tick1}');
}),
```

&emsp; [back to details][]

<br>

<!-- same as Case 3: Use rx automatic aspect -->

## 15. Touch the rx variable

When using rx automatic aspect, but the create method does not use any rx variables, then you can use `model.rxVar.touch()` which the widget depends on that `rxVar` to activate rx automatic aspect.
<br> For example, when changing locale, the create method doesn't have to display the value of the locale, then you can use `model.locale.touch()` to activate rx automatic aspect.

```dart
rxSub<MyModel>((context, model) {
  model.locale.touch();
  final hello = 'app.hello'.i18n(context);
  return const Text('$hello');
})
```

&emsp; [back to details][]

<br>

## 16. Subscribe an aspect

For example, subscribe to a `String` aspect **_`'int1'`_** of class **_`<MyModel>`_**.

- simple form

```dart
'int1'.subModel<MyModel>((context, model) => Text('Int1 is ${model.int1}')),
```

- original form

```dart
Subscriber<MyModel>(
  aspects: 'int1',
  create: (context, model) {
    return Text('Int1 is ${model.int1}');
  },
),
```

- with user extension

```dart
'int1'.subMyModel((context, model) => Text('Int1 is ${model.int1}')),
```

&emsp; [back to details][]

<br>

## 17. Subscribe multiple aspects

Place aspects in a list to subscribe multiple aspects.

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

- original form

```dart
Subscriber<MyModel>(
  aspects: ['int1', 'star'],
  create: (context, model) {
    return Text(
      'Int1 is ${model.int1} and Star is ${model.star}',
      softWrap: true,
      textAlign: TextAlign.center,
    );
  },
),
```

- with user extension

```dart
['int1', 'star'].subMyModel(
  (context, model) => Text(
    'Int1 is ${model.int1} and Star is ${model.star}',
    softWrap: true,
    textAlign: TextAlign.center,
  ),
),
```

&emsp; [back to details][]

<br>

## 18. Subscribe all aspects

Provide no aspects parameter, or use null as aspect to subscribe to all aspects of the model.
<br> See also [allSubscriber@main.dart][].

- simple form

```dart
null.subModel<MyModel>( // null aspects means broadcasting to the model
  (context, model) {
    final aspects = model.frameAspects;
    final str = aspects.isEmpty ? '' : '$aspects received';
    return Text(str, softWrap: true, textAlign: TextAlign.center);
  },
),

```

- original form

```dart
Subscriber<MyModel>(
   // aspects: , // no aspects parameter means broadcasting to the model
  create: (context, model) {
    final aspects = model.frameAspects;
    final str = aspects.isEmpty ? '' : '$aspects received';
    return Text(str, softWrap: true, textAlign: TextAlign.center);
  },
),
```

- with user extension

```dart
null.subMyModel( // null aspects means broadcasting to the model
  (context, model) {
    final aspects = model.frameAspects;
    final str = aspects.isEmpty ? '' : '$aspects received';
    return Text(str, softWrap: true, textAlign: TextAlign.center);
  },
),

```

&emsp; [back to details][]

<br>

## 19. Subscribe with enum aspects

You can use `enum` as aspect.
<br> For example, first, define the enum.

```dart
/// list_model.dart
enum ListEnum {
  ListUpdate,
}
```

Then everything is the same as `String` aspect, just to replace the `String` with `enum`.
<br> See also [cardPage@main.dart][].

- simple form

```dart
ListEnum.ListUpdate.subModel<ListModel>((context, model) {
  /* create method */
}),
```

- original form

```dart
Subscriber<ListModel>(
  aspects: ListEnum.ListUpdate,
  create: (context, model) {
    /* create method */
}),
```

- with user extension

```dart
ListEnum.ListUpdate.subMyModel((context, model) {
  /* create method */
}),
```

&emsp; [back to details][]

<br>

## 20. Manage rx aspects - Chain react aspects

### **Chain react aspects:**

Supposed you need to rebuild a widget whenever a model variable is updated, but it has nothing to do with the variable. Then you can use chain react aspects.
<br> For example, to rebuild a widget whenever **_`str1`_** of class **_`<MyModel>`_** is updated, and chained by the aspect **`'chainStr1'`**.

```dart
/// my_model.dart
final str1 = 's'.rx..addRxAspects('chainStr1'); // to chain react aspects
```

```dart
/// main.dart
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

&emsp; [back to details][]

<br>

## 21. Implement a custom rx class

If you need to write your own rx class, see [custom_rx_class.dart](https://github.com/rob333/flutter_mediator/blob/main/example/lib/custom_rx_class.dart) for example.
<br> Or you can manipulate the underlying `value` directly. For example,

```dart
/// someclass.dart
class SomeClass {
  int counter = 0;
}

final rxClass = SomeClass().rx;
void updateSomeClass() {
  rxClass.value.counter++;
  rxClass.publishRxAspects();
}
```

> By using the `extension`, every object can turn into a rx variable.

&emsp; [back to details][]

<br>

## 22. Aspect type

<!-- same as Key contepts : widget aspects -->

- Widget aspects - Aspects denotes what the widget is interested in.
- Frame aspects - Aspects which will rebuild the related widgets in the next UI frame.
- Registered aspects - Aspects of the model that has been registered.
- RX aspects - Aspects that have been attached to the rx variable. The rx variable will rebuild the related widgets whenever updated.

&emsp; [back to details]

<br>

<!-- &nbsp;&nbsp; -->

## Changelog

Please see the [Changelog](https://github.com/rob333/flutter_mediator/blob/main/CHANGELOG.md) page.

<br>

## License

Flutter Mediator is distributed under the MIT License. See [LICENSE](https://github.com/rob333/flutter_mediator/blob/main/LICENSE) for more information.

[allsubscriber@main.dart]: https://github.com/rob333/flutter_mediator/blob/main/example/lib/main.dart#L160
[cardpage@main.dart]: https://github.com/rob333/flutter_mediator/blob/main/example/lib/main.dart#L118
[back to details]: #details
