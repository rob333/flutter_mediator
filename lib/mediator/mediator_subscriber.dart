import 'package:flutter/widgets.dart';

import 'mediator_host.dart';
import 'mediator_publisher.dart';
import 'rx/rx_impl.dart';

typedef CreaterOfSubscriber<MyModel extends Publisher> = Widget Function(
    BuildContext, MyModel);

@immutable
class Subscriber<MyModel extends Publisher> extends StatelessWidget {
  const Subscriber({
    Key key,
    this.aspects,
    @required this.create,
  })  : assert(create != null),
        super(key: key);

  final Object aspects;
  final CreaterOfSubscriber<MyModel> create;

  @override
  Widget build(BuildContext context) {
    Iterable<Object> passAspects;
    if (aspects is Iterable) {
      passAspects = aspects as Iterable<Object>;
    } else if (aspects != null) {
      passAspects = [aspects];
    }

    final inheritModel = Host.register<MyModel>(context, aspects: passAspects);
    assert(inheritModel.state != null);
    final state = inheritModel.state;

    if (passAspects != null) {
      // add to the RegAspects of the host state
      state.addRegAspects(passAspects);
    }

    // enable auto add static rx aspects to rx aspects - by getter
    RxImpl.enableCollectAspect(passAspects);
    // any rx variable used inside the create function will automatically rebuild the widget when updated
    final widget = create(context, state.widget.model);
    // disable auto add static rx aspects to rx aspects - by getter
    RxImpl.disableCollectAspect();
    return widget;
  }
}
