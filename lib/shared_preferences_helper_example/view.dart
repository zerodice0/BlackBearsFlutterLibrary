import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences_helper/shared_preferences_helper.dart';

class SharedPreferencesHelperExample extends StatelessWidget {
  final SharedPreferencesHelper sharedPreferencesHello =
      SharedPreferencesHelper<String>("Hello");
  final TextEditingController textEditingControllerHello =
      TextEditingController();

  SharedPreferencesHelperExample() {
    sharedPreferencesHello.fetch().then((value) {
      textEditingControllerHello.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
