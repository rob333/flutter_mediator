import 'rx/rx_impl.dart';

class Publisher {
  Publisher() : publish = dummyCallback {
    RxImpl.setPublisher(this);
    print('RxImpl set publisher to: $this');
  }

  CallbackOfPublisher publish;
  Set<Object> _frameAspects; // for reference of frameAspect of host state
  Set<Object> get frameAspect => _frameAspects;

  void setCallback(CallbackOfPublisher cb, Set<Object> frameAspects) {
    publish = cb;
    _frameAspects = frameAspects;
  }

  void restoreCallback() {
    publish = dummyCallback;
    _frameAspects = null;
  }

  // Model may update variables before Host init state
  static void dummyCallback([Object aspects]) {}
}

typedef CallbackOfPublisher = void Function([Object]);
// typedef CallbackOfMediator<AspectType> = void Function([AspectType]);
