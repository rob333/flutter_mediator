import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mediator/mediator.dart';

enum SettingEnum {
  hello,
  thanks,
}

class Setting extends Pub {
  //* member variables
  var locale = 'en'.rx;

  //* controller function
  Future<void> changeLocale(BuildContext context, String countryCode) async {
    final loc = Locale(countryCode);
    await FlutterI18n.refresh(context, loc);
    locale.value = countryCode;
    // locale is a rx variable, will rebuild related widget when updated.
  }

  //* View Map:
  void addSub(Object o, CreatorFn<Setting> sub) => regSub<Setting>(o, sub);
  void addCon(Object o, CreatorFn<Setting> con) => regCon<Setting>(o, con);

  @override
  void init() {
    addSub(SettingEnum.hello, (context, model) {
      model.locale.touch(); // to activate rx automatic aspect
      final hello = 'app.hello'.i18n(context);
      return Text('$hello ');
    });

    addSub(SettingEnum.thanks, (context, model) {
      model.locale.touch(); // to activate rx automatic aspect
      final thanks = 'app.thanks'.i18n(context);
      return Text('$thanks.');
    });

    super.init();
  }
}

//* Model extension
Setting getSetting(BuildContext context) => Pub.model<Setting>();

Subscriber<Setting> subSetting(CreatorFn<Setting> create,
    {Key key, Object aspects}) {
  return Subscriber<Setting>(key: key, aspects: aspects, create: create);
}

extension SettingExtT<T> on T {
  Subscriber<Setting> subSetting(CreatorFn<Setting> create, {Key key}) {
    return Subscriber<Setting>(key: key, aspects: this, create: create);
  }
}

//* i18n extension
extension StringI18n on String {
  String i18n(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }
}
