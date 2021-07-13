import 'package:example/searching_page.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daum Postcode Search Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DaumPostcodeSearchExample(title: 'Daum Postcode Search Example'),
    );
  }
}

class DaumPostcodeSearchExample extends StatefulWidget {
  DaumPostcodeSearchExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _DaumPostcodeSearchExampleState createState() =>
      _DaumPostcodeSearchExampleState();
}

class _DaumPostcodeSearchExampleState extends State<DaumPostcodeSearchExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchingPage(),
                    ),
                  );
                },
                icon: Icon(Icons.search),
                label: Text("주소 검색"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
