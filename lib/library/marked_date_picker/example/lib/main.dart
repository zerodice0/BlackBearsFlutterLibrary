import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marked_date_picker/marked_date_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarkedDatePicker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          DateTime? selectedDate = await showMarkedDatePicker(
            context: context,
            initialDate: date,
            lastDate: DateTime.now(),
            firstDate: DateTime(2019),
          );

          if (selectedDate != null) {
            setState(() {
              date = selectedDate;
            });
          }
        },
        child: Text(DateFormat("yyyy-MM-dd").format(date)),
      )),
    );
  }
}
