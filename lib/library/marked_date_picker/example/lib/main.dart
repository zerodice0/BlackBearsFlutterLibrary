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
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.lightGreen[100]!,
        ),
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

  List<DateTime> markedDates = [];

  ValueNotifier<List<DateTime>> markedDatesNotifier =
      ValueNotifier<List<DateTime>>(
    [
      DateTime.parse("2021-09-01"),
      DateTime.parse("2021-09-03"),
      DateTime.parse("2021-09-07"),
      DateTime.parse("2021-09-29"),
    ],
  );

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

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
            lastDate: now,
            firstDate: DateTime(2019),
            markedDates: markedDates,
            markedDatesListenable: markedDatesNotifier,
            updateMonthCallback: (year, month) {
              markedDatesNotifier.value = month % 2 == 1
                  ? [
                      DateTime.parse("2021-09-01"),
                      DateTime.parse("2021-09-03"),
                      DateTime.parse("2021-09-07"),
                      DateTime.parse("2021-09-29"),
                    ]
                  : [
                      DateTime.parse("2021-08-02"),
                      DateTime.parse("2021-08-04"),
                      DateTime.parse("2021-08-09"),
                      DateTime.parse("2021-08-10"),
                    ];
            },
            marking: Container(
              color: Colors.lightGreen[100],
              child: const Icon(Icons.check, color: Colors.white),
            ),
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
