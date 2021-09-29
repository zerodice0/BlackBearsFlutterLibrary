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

  late ValueNotifier<List<DateTime>> markedDatesNotifier;

  @override
  void initState() {
    super.initState();

    markedDatesNotifier = ValueNotifier<List<DateTime>>(
      _getMarkedList(date.year, date.month),
    );
  }

  List<DateTime> _getMarkedList(int year, int month) {
    String prefix;
    if (month < 10) {
      prefix = "$year-0$month";
    } else {
      prefix = "$year-$month";
    }
    return month % 2 == 1
        ? [
            DateTime.parse("$prefix-01"),
            DateTime.parse("$prefix-02"),
            DateTime.parse("$prefix-03"),
            DateTime.parse("$prefix-07"),
            DateTime.parse("$prefix-29"),
          ]
        : [
            DateTime.parse("$prefix-02"),
            DateTime.parse("$prefix-04"),
            DateTime.parse("$prefix-09"),
            DateTime.parse("$prefix-10"),
          ];
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat("yyyy-MM-dd").format(date)),
            ElevatedButton(
              onPressed: () async {
                DateTime? selectedDate = await showMarkedDatePicker(
                  context: context,
                  initialDate: date,
                  lastDate: now,
                  firstDate: DateTime(2019),
                  markedDates: markedDates,
                  markedDatesListenable: markedDatesNotifier,
                  updateMonthCallback: (year, month) {
                    markedDatesNotifier.value = _getMarkedList(year, month);
                  },
                );

                if (selectedDate != null) {
                  setState(() {
                    date = selectedDate;
                  });
                }
              },
              child: const Text("non-customized"),
            ), //non-customized
            ElevatedButton(
              onPressed: () async {
                DateTime? selectedDate = await showMarkedDatePicker(
                  context: context,
                  initialDate: date,
                  lastDate: now,
                  firstDate: DateTime(2019),
                  markedDates: markedDates,
                  markedDatesListenable: markedDatesNotifier,
                  updateMonthCallback: (year, month) {
                    markedDatesNotifier.value = _getMarkedList(year, month);
                  },
                  marking: Container(
                    color: Colors.lightGreen[100],
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  todayColor: Colors.red,
                  markedColor: Colors.yellow,
                  selectedDayColor: Colors.green,
                  selectedDayBackground: Colors.black,
                );

                if (selectedDate != null) {
                  setState(() {
                    date = selectedDate;
                  });
                }
              },
              child: const Text("Customized"),
            ),
          ],
        ),
      ),
    );
  }
}
