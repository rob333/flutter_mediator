import 'package:flutter/foundation.dart';

import '../mediator.dart';

//* Assert if obj exists, otherwise throw error message.
bool shouldExists(Object? obj, String errmsg) {
  if (obj == null) throw FlutterError(errmsg);
  return true;
}

//* Assert if obj not exists, otherwise throw error message.
bool shouldNull(Object? obj, String errmsg) {
  if (obj != null) throw FlutterError(errmsg);
  return true;
}

//* Assert inheritedModel is not null. i.e. the InheritedModel works properly.
bool ifInheritedModel<Model extends Pub>(
    InheritedMediator<Model>? inheritedModel) {
  if (inheritedModel == null)
    throw FlutterError(
        'Could not find an ancestor of InheritedMediator<$Model>, check if <$Model> is correct.');
  return true;
}

//* Assert template `<Model>` is provided.
bool ifModelTypeCorrect(Type model, String fnstr) {
  if (model is Pub)
    throw FlutterError('$fnstr: Please specify the model type, <$model>');
  return true;
}

//* Assert rx auto aspect is not empty, i.e. rx automatic aspect is actived.
bool ifRxAutoAspectEmpty(List<Object> rxAutoAspectList) {
  if (rxAutoAspectList.isEmpty)
    throw FlutterError(
        'Flutter Mediator Error: No watched variable found in the widget.\n'
        'Try using `watchedVar.consume` or `model.rxVar.touch()`.\n'
        'Or use at least one watched variable in the widget.');
  return true;
}

//* Pub: Assert get model exists.
bool ifStateModel<Model extends Pub>(Pub? model) {
  if (model == null) throw FlutterError('Host.model<$Model> not exists');
  return true;
}

//* rx_impl: Assert tag not to exceed maximum.
bool ifTagMaximum(int rxTagCounter) {
  if (rxTagCounter == 0x7fffffffffffffff)
    throw FlutterError('Rx Tag exceeded maximum.');
  return true;
}
