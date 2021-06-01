import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences_helper/shared_preferences_helper.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SharedPreferencesHelperExample(),
      ),
    ),
  );
}

class SharedPreferencesManager {
  static SharedPreferencesHelper<String> stringValue =
      SharedPreferencesHelper("stringValue");
  static SharedPreferencesHelper<int> intValue =
      SharedPreferencesHelper("intValue");
  static SharedPreferencesHelper<double> doubleValue =
      SharedPreferencesHelper("doubleValue");
  static SharedPreferencesHelper<bool> booleanValue =
      SharedPreferencesHelper("booleanValue");
  static SharedPreferencesHelper<List<String>> stringListValue =
      SharedPreferencesHelper("stringListValue");
}

class SharedPreferencesHelperExample extends StatefulWidget {
  @override
  _SharedPreferencesHelperExampleState createState() =>
      _SharedPreferencesHelperExampleState();
}

class _SharedPreferencesHelperExampleState
    extends State<SharedPreferencesHelperExample> {
  final TextEditingController textEditingControllerHello =
      TextEditingController();
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferencesManager.stringValue.fetch("Hello").then((value) {
      textEditingControllerHello.text = value;
    });

    SharedPreferencesManager.booleanValue.fetch(false).then((value) {
      setState(
        () => this._switchValue = value,
      );
    });

    SharedPreferencesManager.stringListValue.fetch(<String>[]).then((value) {
      value.forEach((element) => print(element));
    });

    textEditingControllerHello.addListener(() {
      SharedPreferencesManager.stringValue
          .update(textEditingControllerHello.text);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences Helper"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Shared Preferences Helper Example."),
          CupertinoTextField(
            controller: textEditingControllerHello,
          ),
          CupertinoSwitch(
            value: _switchValue,
            onChanged: (value) {
              SharedPreferencesManager.booleanValue.update(value);

              setState(
                () => this._switchValue = value,
              );
            },
          ),
        ],
      ),
    );
  }
}
