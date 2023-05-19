import 'package:flutter/material.dart';
import 'package:flutter_mediator/mediator.dart';

//* Step1: import the var.dart
import '../var.dart';

class LocalePage extends StatelessWidget {
  const LocalePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* Get the watched variable by tag:'tagCount' from `../main.dart`
    final mainInt = globalGet(tag: 'tagCount');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Text(
          'Global Mode: Locale demo',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 25),
        //* `globalConsume` the watched variable from `../main.dart`
        globalConsume(
          () => Text(
            'You have pressed the button at the first page ${mainInt.value} times',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        globalConsume(
          () => Text(
            'Data length at the second page ${data.value.length}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        globalConsume(
          () => Text(
            locstr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        globalConsumeAll(() {
          final txt =
              globalFrameAspects.isEmpty ? '' : 'Updated: $globalFrameAspects';
          return Text(
            txt,
            style: const TextStyle(fontSize: 16),
          );
        }),
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
          //* Step3: Create a consumer widget with
          //* `globalConsume` or `watchedVar.consume` to register the
          //* watched variable to the host to rebuild it when updating.
          locale.consume(() => Text('${'app.hello'.i18n(context)} ')),
          Text('$name, '),
          //* Or use the ci18n extension
          'app.thanks'.ci18n(context),
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

  _handleRadioValueChange1(Object? value) async {
    await changeLocale(context, value! as String);
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

    return SizedBox(
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
