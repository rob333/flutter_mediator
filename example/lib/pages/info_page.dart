import 'package:flutter/material.dart';
import 'package:flutter_mediator/mediator.dart';
import 'package:flutter_mediator_example/models/setting_model.dart';

import '../models/list_model.dart';
import '../models/my_model.dart';
import '../widgets/widget_extension.dart';

Widget infoPage() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        SizedBox(
          height: 125,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const InfoPanel().center(),
            ],
          ),
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

class LocalePanel extends StatelessWidget {
  const LocalePanel({Key? key}) : super(key: key);

  Widget txt(String name) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Pub.sub<Setting>(SettingEnum.hello),
          Text('$name, '),
          Pub.sub<Setting>(SettingEnum.thanks),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (final name in names) txt(name),
      ],
    );
  }
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('MyModel:'),
        Pub.sub<MyModel>('tick1'),
        const SizedBox(height: 30),

        Pub.sub<ListModel>(ListEnum.ViewUpdate),
        //// ListEnum.ListUpdate.subListModel((context, listModel) {
        // ListEnum.ListUpdate.subModel<ListModel>((context, listModel) {
        //   return Column(
        //     children: [
        //       const Text('ListModel:'),
        //       Text('sales:${listModel.data.length}'),
        //       Text('Total units:${listModel.getTotalUnits()}'),
        //     ],
        //   );
        // }),
      ],
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
    final model = Host.model<Setting>();
    await model.changeLocale(context, value!);
    setState(() {
      // model.locale.value = value; // in model.changeLocale
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Host.model<Setting>();
    final _radioValue1 = model.locale.value;

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
