import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mediator/mediator.dart';

//* Step1: Declare the watched variable with `globalWatch`.
var locale = globalWatch('en');

class LocalePage extends StatelessWidget {
  const LocalePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Text(
            'Global Mode: Locale demo',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              RadioGroup(),
              LocalePanel(),
            ],
          ),
        ],
      ),
    );
  }
}

class LocalePanel extends StatelessWidget {
  const LocalePanel({Key? key}) : super(key: key);

  Widget txt(BuildContext context, String name) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          //* Step3: Create the widget with `globalConsume` or `watchedVar.consume`,
          //* i.e. register the watched variable to the host to rebuild the widget when updating.
          //* `watchedVar.consume()` is a helper function to `touch()` itself first then `globalConsume`.
          locale.consume(() {
            return Text('${'app.hello'.i18n(context)} ');
          }),
          Text('$name, '),
          //* Step3: Create the widget with `globalConsume` or `watchedVar.consume`,
          //* i.e. register the watched variable to the host to rebuild the widget when updating.
          //* `watchedVar.consume()` is a helper function to `touch()` itself first then `globalConsume`.
          locale.consume(() {
            return Text('${'app.thanks'.i18n(context)}.');
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (final name in names) txt(context, name),
      ],
    );
  }
}

class RadioGroup extends StatefulWidget {
  const RadioGroup({
    Key? key,
  }) : super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  final locales = ['en', 'fr', 'nl', 'de', 'it', 'jp', 'kr'];
  final languages = [
    'English',
    'français',
    'Dutch',
    'Deutsch',
    'Italiano',
    '日本語',
    '한국어',
  ];

  Future<void> _handleRadioValueChange1(String? value) async {
    await changeLocale(context, value!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _radioValue1 = locale.value;

    Widget panel(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio(
            value: locales[index],
            groupValue: _radioValue1,
            onChanged: _handleRadioValueChange1,
          ),
          Text(
            languages[index],
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      );
    }

    return Container(
      width: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var i = 0; i < locales.length; i++) panel(i),
        ],
      ),
    );
  }
}

Future<void> changeLocale(BuildContext context, String countryCode) async {
  final loc = Locale(countryCode);
  await FlutterI18n.refresh(context, loc);
  //* Step4: Make an update to the watched variable.
  locale.value = countryCode;
}

//* i18n extension
extension StringI18n on String {
  String i18n(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }
}

final names = [
  'Aarron',
  'Josh',
  'Ibraheem',
  'Rosemary',
  'Clement',
  'Kayleigh',
  'Elisa',
  'Pearl',
  'Aneesah',
  'Tom',
  'Jordana',
  'Taran',
  'Bethan',
  'Haydon',
  'Olivia-Mae',
  'Anam',
  'Kelsie',
  'Denise',
  'Jenson',
  'Piotr',
];
