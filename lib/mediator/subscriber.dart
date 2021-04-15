import 'package:flutter/widgets.dart';

import 'assert.dart';
import 'host.dart';
import 'pub.dart';
import 'rx/rx_impl.dart';

/// The consume widget class
@immutable
class Subscriber<Model extends Pub> extends StatelessWidget {
  /// Create a consume widget.
  ///
  /// [aspects] : register the aspects with the consume widget. This widget
  /// will rebuild whenever any aspect in the [aspects] is notified.
  ///
  /// [rxAuto] : if enable automatic aspect management, i.e. any watched
  /// variable value used inside the [create] function will rebuild the
  /// consume widget when updating the value of the watched variable.
  ///
  /// [create] : create a child widget of this consume widget.
  const Subscriber({
    Key? key,
    this.aspects,
    required this.create,
    this.rxAuto,
  }) : super(key: key);

  final Object? aspects;
  final CreatorFn<Model> create;
  final bool? rxAuto; // if automatic generate aspects for user

  @override
  Widget build(BuildContext context) {
    if (rxAuto == true) {
      /// rx automatic aspect
      /// automatic generates aspects for the widget
      RxImpl.enableRxAutoAspect();
      final model = Host.model<Model>();
      final widget = create(context, model);
      final rxAutoAspectList = RxImpl.getAndDisableRxAutoAspect();

      assert(ifRxAutoAspectEmpty(rxAutoAspectList));

      Host.register<Model>(context, aspects: rxAutoAspectList);
      // addRegAspect automatically in the RxImpl getter

      RxImpl.clearRxAutoAspects();
      return widget;
      //
    } else {
      /// with specific aspects from the parameter
      Iterable<Object>? widgetAspects;
      if (aspects is Iterable<Object>) {
        widgetAspects = aspects as Iterable<Object>;
      } else if (aspects != null) {
        widgetAspects = [aspects!];
      }

      // register widgetAspects to the host, and add to [regAspects]
      final model = Host.register<Model>(context, aspects: widgetAspects);

      // enable automatic add static rx aspects to rx aspects - by getter
      RxImpl.enableCollectAspect(widgetAspects);
      // any rx variable used inside the create method will automatically rebuild related widgets when updating
      final widget = create(context, model);
      // disable automatic add static rx aspects to rx aspects - by getter
      RxImpl.disableCollectAspect();
      return widget;
    }
  }
}

/// The consume widget class with automatic aspect management.
///
/// A lite version of the Subscribe class,
/// used specially for Global Mode.
@immutable
class SubscriberAuto<Model extends Pub> extends StatelessWidget {
  /// Create a consume widget.
  ///
  /// Register to the host to rebuild when any of the watched variable value
  /// used inside this widget is updating; or use `watchedVar.consume` to
  /// `touch()` the watched variable first.
  ///
  /// [create] : create a child widget of this consume widget.
  const SubscriberAuto({
    Key? key,
    required this.create,
  }) : super(key: key);

  final Widget Function() create;

  @override
  Widget build(BuildContext context) {
    RxImpl.enableRxAutoAspect();
    final widget = create();
    final rxAutoAspectList = RxImpl.getAndDisableRxAutoAspect();

    assert(ifRxAutoAspectEmpty(rxAutoAspectList));

    Host.register<Model>(context, aspects: rxAutoAspectList);
    // addRegAspect automatically in the RxImpl getter

    RxImpl.clearRxAutoAspects();
    return widget;
  }
}

/// A function for the Subscriber to create a `rx automatic aspect` widget.
Subscriber<Model> rxSub<Model extends Pub>(CreatorFn<Model> create,
    {Key? key}) {
  assert(shouldExists(create, 'rxSub: Create method should not be null.'));
  return Subscriber<Model>(key: key, create: create, rxAuto: true);
}

/// Extension for rx automatic aspect from create method [CreatorFn].
extension RxAutoAspectExt on CreatorFn {
  Subscriber<T> rxSub<T extends Pub>({Key? key}) {
    return Subscriber<T>(key: key, create: this, rxAuto: true);
  }
}

/// Extension for aspect from any type of [T].
extension ModelAspectExtT<T> on T {
  Subscriber<Model> subModel<Model extends Pub>(CreatorFn<Model> create,
      {Key? key}) {
    return Subscriber<Model>(key: key, aspects: this, create: create);
  }
}

typedef CreatorFn<Model extends Pub> = Widget Function(
    BuildContext context, Model model);
