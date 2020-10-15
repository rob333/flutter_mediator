import 'package:flutter/widgets.dart';

import '../mediator.dart';

@immutable
class Controller<Model extends Pub> extends StatelessWidget {
  const Controller({Key key, @required this.create})
      : assert(create != null),
        super(key: key);

  final CreatorFn<Model> create;

  @override
  Widget build(BuildContext context) {
    final model = Pub.model<Model>();
    return create(context, model);
  }
}
