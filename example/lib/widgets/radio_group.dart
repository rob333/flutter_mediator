import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mediator/mediator.dart';

import '../models/list_model.dart';

class RadioGroup extends StatefulWidget {
  const RadioGroup({
    Key key,
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
    '日文',
    '한글',
  ];

  Future<void> _handleRadioValueChange1(String value) async {
    final model = Pub.model<ListModel>();
    await model.changeLocale(context, value);
    setState(() {
      // model.locale.value = value; // in model.changeLocale
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Pub.model<ListModel>();
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
