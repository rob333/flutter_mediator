import 'package:flutter/widgets.dart';

import '../mediator.dart';

//* Aspect extension
extension ModelAspectExtT<T> on T {
  Subscriber<Model> subModel<Model extends Pub>(CreatorFn<Model> create,
      {Key? key}) {
    return Subscriber<Model>(key: key, aspects: this, create: create);
  }
}

//* Context extension
/*
extension ListModelExtT<T> on List<T> {
  Subscriber<Model> subModel<Model extends Pub>(
      CreatorFn<Model> create,
      {Key key}) {
    return Subscriber<Model>(key: key, aspects: this, create: create);
  }
}

extension IterableModelExtT<T> on Iterable<T> {
  Subscriber<Model> subModel<Model extends Pub>(
      CreatorFn<Model> create,
      {Key key}) {
    return Subscriber<Model>(key: key, aspects: this, create: create);
  }
}
*/
