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

class SharedPreferencesHelperExample extends StatelessWidget {
  final SharedPreferencesHelper sharedPreferencesHello =
      SharedPreferencesHelper<String>("Hello");
  final TextEditingController textEditingControllerHello =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    sharedPreferencesHello.fetch("Hello").then((value) {
      textEditingControllerHello.text = value;
    });

    textEditingControllerHello.addListener(() {
      sharedPreferencesHello.update(textEditingControllerHello.text);
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
          )
        ],
      ),
    );
  }
}
