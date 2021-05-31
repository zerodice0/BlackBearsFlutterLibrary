import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_helper/shared_preferences_helper.dart';

void main() {
  SharedPreferencesHelper<String> testString =
      SharedPreferencesHelper<String>("testString");
  testWidgets("SharedPreferencesHelper Test", (WidgetTester tester) async {
    String test = await testString.fetch("testString");
    expect(test, "testString");
  });
}
