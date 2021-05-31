library shared_preferences_helper;

import 'package:shared_preferences/shared_preferences.dart';

typedef _GeneratedFetchFunction<T> = Future<T> Function(T defaultValue,
    {SharedPreferences sharedPreferences});
typedef _GeneratedUpdateFunction<T> = Future<bool> Function(T value,
    {SharedPreferences sharedPreferences});
typedef _GeneratedRemoveFunction = Future<bool> Function(
    {SharedPreferences sharedPreferences});
typedef _StringList = List<String>;

class _SharedPreferenceHelperWrapper {
  static _GeneratedRemoveFunction removeGenerator(String key) {
    return ({SharedPreferences? sharedPreferences}) async {
      if (sharedPreferences == null) {
        sharedPreferences = await SharedPreferences.getInstance();
      }

      return sharedPreferences.remove(key);
    };
  }

  static _GeneratedUpdateFunction<T> updateGenerator<T>(String key) {
    return (T value, {SharedPreferences? sharedPreferences}) async {
      bool result = false;

      if (sharedPreferences == null) {
        sharedPreferences = await SharedPreferences.getInstance();
      }

      switch (T) {
        case String:
          result = await sharedPreferences.setString(key, value as String);
          break;
        case bool:
          result = await sharedPreferences.setBool(key, value as bool);
          break;
        case double:
          result = await sharedPreferences.setDouble(key, value as double);
          break;
        case int:
          result = await sharedPreferences.setInt(key, value as int);
          break;
        case _StringList:
          result =
              await sharedPreferences.setStringList(key, value as _StringList);
          break;
        default:
          break;
      }

      return result;
    };
  }

  static _GeneratedFetchFunction<T> fetchGenerator<T>(String key) {
    return (T defaultValue, {SharedPreferences? sharedPreferences}) async {
      T result = defaultValue;

      if (sharedPreferences == null) {
        sharedPreferences = await SharedPreferences.getInstance();
      }

      switch (T) {
        case String:
          result = (sharedPreferences.getString(key) ?? defaultValue) as T;
          break;
        case bool:
          result = (sharedPreferences.getBool(key) ?? defaultValue) as T;
          break;
        case double:
          result = (sharedPreferences.getDouble(key) ?? defaultValue) as T;
          break;
        case int:
          result = (sharedPreferences.getInt(key) ?? defaultValue) as T;
          break;
        case List:
          result = (sharedPreferences.getStringList(key) ?? defaultValue) as T;
          break;
        default:
          result = (sharedPreferences.get(key) ?? defaultValue) as T;
          break;
      }

      return result;
    };
  }
}

class SharedPreferencesHelper<T> extends _SharedPreferenceHelperWrapper {
  final String key;

  SharedPreferencesHelper(this.key);

  Future<T> fetch(T defaultValue) =>
      _SharedPreferenceHelperWrapper.fetchGenerator<T>(key)(defaultValue);
  Future<bool> update(T value) =>
      _SharedPreferenceHelperWrapper.updateGenerator<T>(key)(value);
  Future<bool> remove() =>
      _SharedPreferenceHelperWrapper.removeGenerator(key)();
}
