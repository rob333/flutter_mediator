import 'package:flutter/widgets.dart';

import '../mediator.dart';

//* Aspect helper
extension ModelAspectHelperT<T> on T {
  Subscriber<Model> subModel<Model extends Publisher>(
      CreaterOfSubscriber<Model> create,
      {Key key}) {
    return Subscriber<Model>(key: key, aspects: this, create: create);
  }
}

//* Context helper
extension BuildContextHelper on BuildContext {
  Model getModel<Model extends Publisher>() {
    return Host.getInheritOfModel<Model>(this);
  }
}

//* Model helper
extension ModelHelper<T extends Publisher> on T {
  Model getModel<Model extends Publisher>(BuildContext context) {
    return Host.getInheritOfModel<Model>(context);
  }
}

/*
extension ListModelHelperT<T> on List<T> {
  Subscriber<Model> subModel<Model extends Publisher>(
      CreaterOfSubscriber<Model> create,
      {Key key}) {
    return Subscriber<Model>(key: key, aspects: this, create: create);
  }
}

extension IterableModelHelperT<T> on Iterable<T> {
  Subscriber<Model> subModel<Model extends Publisher>(
      CreaterOfSubscriber<Model> create,
      {Key key}) {
    return Subscriber<Model>(key: key, aspects: this, create: create);
  }
}
*/
