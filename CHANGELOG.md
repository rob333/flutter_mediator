## 2.2.5

- Adds a type alias of Rx class as `Signal`. Allows you to initialize mediator variables with the `Signal` annotation.
  
  For example,
```dart
final _int1 = 0.signal;
final _int2 = Signal(0); 
final _int3 = Signal(0); 
// computed mediator variable
final _sum = Signal(() => int1 + int2 + int3);
```


## 2.2.3

- Support mediator variable of type `Function`, to use as a **computed** mediator variable.

  For example,
```dart
final _sum = Rx(() => int1 + int2 + int3 as dynamic); // use `dynamic` if the return type along with the computed function will change
get sum => _sum.value;
set sum(value) => _sum.value = value;
```


## 2.2.2

- Imporve `RxList`, `RxSet`, and `RxMap`.

## 2.2.1

- Fix example and document.

## 2.2.0

- Fix example and migrate to flutter 2.8

## 2.1.6

- Improve documents.
- Add `globalHost` for compatibility with lite and persistence version.

## 2.1.5+3

- Update documents.

## 2.1.5+2

- Update documents.

## 2.1.5+1

- Update documents.
  - Add a branch version, Flutter Mediator Persistence, which provides built in persistence.

## 2.1.5

- Minor improvement.

## 2.1.4

- Fix problems when working with shared_preferences.
  - Fix `WidgetsFlutterBinding.ensureInitialized()` issue.
- Update example to use shared_preferences with locale.

## 2.1.3

- Minor improvements.

## 2.1.2+3

- Change the type of the system tag to `int`.

## 2.1.2+2

- Improve documents.

## 2.1.2+1

- Minor improvements.

## 2.1.2

- Add Global Broadcast capabilities:
  - `globalBroadcast()`, to broadcast to all the globalconsumer widgets.
  - `globalConsumeAll(Widget Function() create, {Key? key})`, to create a widget which will be rebuilt whenever any watched variables changes are made.
  - `globalFrameAspects`, a getter, to return the updated aspects of the Global Mode.
  - `globalAllAspects`, a getter, to return all the aspects that has been registered to the Global Mode.

## 2.1.1+3

- Minor improvement.

## 2.1.1+2

- Fix dartdoc fail.

## 2.1.1+1

- Fix static analysis fail.

## 2.1.1

- Update the example_global_mode, to put the watched variables into a file and then import it.

## 2.1.0

- Add `Global` class for monitoring global variables as `Global Mode`.

  - Add `globalWatch(variable)` to return a watched variable.
  - Add `globalConsume(() => Text('${watchedVar.value}'))` to create a widget that register the watched variable to the host.

  - Add `globalGet<T>({Object? tag})` to retrieve the watched variable from another file.
    - With `globalWatch(variable)`, the watched variable will be retrieved by the `Type` of the variable, i.e. retrieve by `globalGet<Type>()`.
    - With `globalWatch(variable, tag: object)`, the watched variable will be retrieved by the tag, i.e. retrieve by `globalGet(tag: object)`.

- RxImpl class:

  - Add `rxImpl.notify()`, synonym of `rxImpl.publishRxAspects()`, to notify the host to rebuild.

  - Add `rxImpl.ob` (a getter), to `notify()` the host to rebuild and then return the underlying object.

  - Add `rxImpl.consume(Widget Function() fn, {Key? key})`, a helper function to `touch()` itself first and then `globalConsume`.

- Change the first parameter of `MultiHost.create` to named parameter as `MultiHost.create({List<Host>? hosts, required Widget child})`.

- Add an example to demonstrate the usage of the `Global Mode` in the `example_global_mode` folder

## 2.0.1

- Add `Host.model<Model>()`, and deprecate `Pub.model<Model>()`, `Pub.getModel<Model>()`

## 2.0.0

- Null safety support.

## 2.0.0-nullsafety.0

- Migrate to null safety.

## 1.1.2+3

- Fix static analysis fail.

## 1.1.2+2

- Change `InheritedModelOfMediator` to `InheritedMediator` and extends from `InheritedWidget`.

## 1.1.2+1

- Document improvement.

## 1.1.2

- Add `Pub.model<Model>()`, the same as `Pub.getModel<Model>()`.

## 1.1.1

- Add `MultiHost.create`.

## 1.1.0

- Add `rxSub`, rx automatic aspect, generates and maintains aspect for the rx variables automatically.

- Add `Controller` class.

- Add View Map.

- Rename `Publisher` class to `Pub`.

- Remove `Host.getInheritedOfModel<Model>(context)`, use `Pub.getModel<Model>()` instead.

- Update example, add an i18n page.

## 1.0.0+3

- Document improvement.

- Change named parameter `create` of the extension to position parameter.

## 1.0.0+2

- Document improvement.

## 1.0.0+1

- Document improvement.
- Add rx aspects management.

## 1.0.0

- Initial release.
