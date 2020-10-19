import 'package:flutter/foundation.dart';

import '../mediator.dart';

//* Assert if obj exists, otherwise throw error message.
bool shouldExists(Object obj, String errmsg) {
  if (obj == null) throw FlutterError(errmsg);
  return true;
}

//* Assert if obj not exists, otherwise throw error message.
bool shouldNull(Object obj, String errmsg) {
  if (obj != null) throw FlutterError(errmsg);
  return true;
}

//* Assert inheritedModel is not null. i.e. the InheritedModel works properly.
bool ifInheritedModel<Model extends Pub>(
    InheritedMediator<Model> inheritedModel) {
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
        'Use at least one rx variable, or `model.rxVar.touch()`, to activate rx automatic aspect in the `create method` with the rx automatic aspect.');
  return true;
}

//* Pub: Assert get model exists.
bool ifStateModel<Model extends Pub>(Pub model) {
  if (model == null) throw FlutterError('Pub.model<$Model> not exists');
  return true;
}

//* rx_impl: Assert tag not to exceed maximum.
bool ifTagMaximum(int rxTagCounter) {
  if (rxTagCounter == 0x7fffffffffffffff)
    throw FlutterError('RxTagger exceeded maximum.');
  return true;
}
