import 'package:flutter/widgets.dart';

import 'assert.dart';
import 'host.dart';
import 'pub.dart';
import 'rx/rx_impl.dart';

@immutable
class Subscriber<Model extends Pub> extends StatelessWidget {
  const Subscriber({
    Key key,
    this.aspects,
    @required this.create,
    this.rxAuto,
  })  : assert(create != null),
        super(key: key);

  final Object aspects;
  final CreatorFn<Model> create;
  final bool rxAuto; // if automatic generate aspects for user

  @override
  Widget build(BuildContext context) {
    if (rxAuto == true) {
      /// rx automatic aspect
      /// automatic generates aspects for the widget
      RxImpl.enableRxAutoAspect();
      final model = Pub.getModel<Model>();
      final widget = create(context, model);
      final rxAutoAspectList = RxImpl.getAndDisableRxAutoAspect();

      assert(ifRxAutoAspectEmpty(rxAutoAspectList));

      // final inheritedModel =
      Host.register<Model>(context, aspects: rxAutoAspectList);
      //   inheritedModel.state.addRegAspects(rxAutoAspectList);
      /// addRegAspect automatically in the RxImpl getter

      RxImpl.clearRxAutoAspects();
      return widget;
      //
    } else {
      /// with specific aspects from the parameter
      Iterable<Object> widgetAspects;
      if (aspects is Iterable) {
        widgetAspects = aspects as Iterable<Object>;
      } else if (aspects != null) {
        widgetAspects = [aspects];
      }

      final inheritedModel =
          Host.register<Model>(context, aspects: widgetAspects);
      assert(inheritedModel.state != null);
      final state = inheritedModel.state;

      /// add to the RegAspects of the host state
      /// check (widgetAspects == null) inside addRegAspects
      // if (widgetAspects != null) {
      final model = state.addRegAspects(widgetAspects);
      // }

      // enable automatic add static rx aspects to rx aspects - by getter
      RxImpl.enableCollectAspect(widgetAspects);
      // any rx variable used inside the create function will automatically rebuild the widget when updated
      final widget = create(context, model);
      // disable automatic add static rx aspects to rx aspects - by getter
      RxImpl.disableCollectAspect();
      return widget;
    }
  }
}

//* Function of the Subscriber for rx automatic aspect
Subscriber<Model> rxSub<Model extends Pub>(CreatorFn<Model> create, {Key key}) {
  assert(shouldExists(create, 'rxSub: Create method should not be null.'));
  return Subscriber<Model>(key: key, create: create, rxAuto: true);
}

//* Extension for rx automatic aspect create function
extension RxAutoAspectExt on CreatorFn {
  Subscriber<T> rxSub<T extends Pub>({Key key}) {
    return Subscriber<T>(key: key, create: this, rxAuto: true);
  }
}

typedef CreatorFn<Model extends Pub> = Widget Function(
    BuildContext context, Model model);
