import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mediator/mediator.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* Declare a global scope SharedPreferences.
late SharedPreferences prefs;

//* Step1A: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0, tag: 'tagCount'); // main.dart

final data = globalWatch(<ListItem>[]); // list_page.dart

//* Step1B: Declare the persistent watched variable with `late Rx<Type>`
const defaultLocale = 'en';
late Rx<String> locale; // local_page.dart

/// Computed Mediator Variable: locstr
final _locstr = Rx(() => "locale: ${locale.value}" as dynamic);
get locstr => _locstr.value;
set locstr(value) => _locstr.value = value;

final opacityValue = globalWatch(0.0); // scroll_page.dart

class ListItem {
  const ListItem(
    this.item,
    this.units,
    this.color,
  );

  final String item;
  final int units;
  final Color color;
}

/// Initialize the persistent watched variables
/// whose value is stored by the SharedPreferences.
Future<void> initVars() async {
  // To make sure SharedPreferences works.
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  locale = globalWatch(prefs.getString('locale') ?? defaultLocale);
}

/// Change the locale, by `String`[countryCode]
/// and store the setting with SharedPreferences.
Future<void> changeLocale(BuildContext context, String countryCode) async {
  if (countryCode != locale.value) {
    final loc = Locale(countryCode);
    await FlutterI18n.refresh(context, loc);
    //* Step4: Make an update to the watched variable.
    locale.value = countryCode; // will rebuild the registered widget

    await prefs.setString('locale', countryCode);
  }
}

extension StringI18nExt on String {
  /// String extension for i18n.
  String i18n(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }

  /// String extension for i18n and `locale.consume` the widget
  /// to Create a consumer widget for the state management.
  Widget ci18n(BuildContext context, {TextStyle? style}) {
    return locale.consume(
      () => Text(FlutterI18n.translate(context, this), style: style),
    );
  }
}
