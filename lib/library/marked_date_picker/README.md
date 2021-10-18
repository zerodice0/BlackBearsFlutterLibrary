Customized DatePicker for displaying marked dates.
## Features
This is minor-copy of showDatePicker. but maybe you need this if you want marking dates on datepicker.

## Getting started
1. import 'package:marked_date_picker/marked_date_picker.dart';
2. call `showMarkedDatePicker`.
## Usage
```
ValueNotifier<List<DateTime>> markedDatesNotifier = ValueNotifier<List<DateTime>>(
      _getMarkedList(date.year, date.month),
    );

showMarkedDatePicker(
  context: context,
  initialDate: date,
  lastDate: now,
  firstDate: DateTime(2019),
  markedDates: markedDates,
  markedDatesListenable: markedDatesNotifier,
  updateMonthCallback: (year, month) {
    markedDatesNotifier.value = DateTime.parse([
      DateTime.parse("2021-09-02"),
      DateTime.parse("2021-09-04"),
      DateTime.parse("2021-09-09"),
      DateTime.parse("2021-09-10"),
    ]
  },
);
```

## Additional information
- 
