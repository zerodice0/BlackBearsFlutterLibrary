# Marked Date Picker

A customized Flutter DatePicker library for displaying marked dates.

[![pub package](https://img.shields.io/pub/v/marked_date_picker.svg)](https://pub.dev/packages/marked_date_picker)

## Introduction

This library is based on Flutter's default `showDatePicker` but adds the ability to mark specific dates. It's useful when you need to highlight calendar dates for events, schedules, or other important dates.

## Features

- Mark specific dates on the calendar
- Update marked dates list when month changes
- Custom color support (today's date, marked dates, selected date, etc.)
- Custom widget support for markers

## Installation

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  marked_date_picker: ^0.0.4
```

Then install the package:

```
flutter pub get
```

## Usage

1. Import the package:

```dart
import 'package:marked_date_picker/marked_date_picker.dart';
```

2. Call `showMarkedDatePicker`:

```dart
// ValueNotifier to manage the list of marked dates
ValueNotifier<List<DateTime>> markedDatesNotifier = ValueNotifier<List<DateTime>>(
  _getMarkedList(date.year, date.month),
);

// Show the date picker
final DateTime? selectedDate = await showMarkedDatePicker(
  context: context,
  initialDate: date,
  firstDate: DateTime(2019),
  lastDate: DateTime.now(),
  // List of dates to mark
  markedDates: [
    DateTime.parse("2021-09-02"),
    DateTime.parse("2021-09-04"),
    DateTime.parse("2021-09-09"),
    DateTime.parse("2021-09-10"),
  ],
  // Listener to update the marked dates list
  markedDatesListenable: markedDatesNotifier,
  // Callback when month changes
  updateMonthCallback: (year, month) {
    // Load different marked dates for each month
    markedDatesNotifier.value = _getMarkedList(year, month);
  },
  // Optional customization
  todayColor: Colors.blue,
  markedColor: Colors.red,
  selectedDayColor: Colors.white,
  selectedDayBackground: Colors.green,
);

// Example function to get marked dates
List<DateTime> _getMarkedList(int year, int month) {
  // You would fetch marked dates from API or local data here
  return [
    DateTime(year, month, 2),
    DateTime(year, month, 15),
    DateTime(year, month, 20),
  ];
}
```

## Additional Options

`showMarkedDatePicker` supports all options from the base Flutter `showDatePicker` and adds these additional options:

- `markedDates`: List of dates to mark
- `markedDatesListenable`: ValueListenable to dynamically update marked dates when the calendar changes
- `updateMonthCallback`: Callback triggered when month changes
- `marking`: Custom widget for the marker
- `todayColor`: Color for today's date
- `markedColor`: Color for marked dates
- `selectedDayColor`: Text color for the selected date
- `selectedDayBackground`: Background color for the selected date
- `anchorPoint`: Dialog anchor point

## Issues and Contributions

### Reporting Issues

If you encounter any problems or have feature requests, please file an issue on the [GitHub repository](https://github.com/zerodice0/BlackBearsFlutterLibrary/tree/main/lib/library/marked_date_picker). When reporting issues, please include:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior and what actually happened
- Flutter/Dart version and device information
- Screenshots or code samples if applicable

### Contribution Guidelines

Contributions are always welcome! Here's how you can contribute:

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** and ensure they follow the project code style
3. **Submit a pull request** with a clear description of your changes

#### Development Guidelines

- Follow Flutter's [style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Write meaningful commit messages that follow the project's commit convention
- Keep changes focused and separate unrelated changes into different PRs
- Update documentation for any changed functionality

#### Environment Setup

```dart
flutter --version  // Make sure you have Flutter 3.0.0 or higher
flutter pub get    // Install dependencies
```

## License

This project is licensed under the MIT License.

---

See [README-kr.md](README-kr.md) for Korean version.
