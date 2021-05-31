import 'package:blackbear_flutter_library/shared_preferences_helper_example/shared_preferences_helper_example.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BlackBear's Examples"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SharedPreferencesHelperExample(),
                  ),
                );
              },
              child: Text("Shared Preferences Helper"),
            ),
          ],
        ),
      ),
    );
  }
}
