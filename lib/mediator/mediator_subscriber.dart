import 'package:flutter/widgets.dart';

import 'mediator_host.dart';
import 'mediator_publisher.dart';
import 'rx/rx_impl.dart';

typedef CreaterOfSubscriber<Model extends Publisher> = Widget Function(
    BuildContext, Model);

@immutable
class Subscriber<Model extends Publisher> extends StatelessWidget {
  const Subscriber({
    Key key,
    this.aspects,
    @required this.create,
  })  : assert(create != null),
        super(key: key);

  final Object aspects;
  final CreaterOfSubscriber<Model> create;

  @override
  Widget build(BuildContext context) {
    Iterable<Object> widgetAspects;
    if (aspects is Iterable) {
      widgetAspects = aspects as Iterable<Object>;
    } else if (aspects != null) {
      widgetAspects = [aspects];
    }

    final inheritModel = Host.register<Model>(context, aspects: widgetAspects);
    assert(inheritModel.state != null);
    final state = inheritModel.state;

    if (widgetAspects != null) {
      // add to the RegAspects of the host state
      state.addRegAspects(widgetAspects);
    }

    // enable auto add static rx aspects to rx aspects - by getter
    RxImpl.enableCollectAspect(widgetAspects);
    // any rx variable used inside the create function will automatically rebuild the widget when updated
    final widget = create(context, state.widget.model);
    // disable auto add static rx aspects to rx aspects - by getter
    RxImpl.disableCollectAspect();
    return widget;
  }
}
