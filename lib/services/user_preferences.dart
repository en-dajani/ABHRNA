import 'dart:convert';

import 'package:abhrna/models/city.dart';
import 'package:abhrna/models/country.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _countryKey = 'saved_country';
  static const _cityKey = 'saved_city';

  /// ✅ حفظ الدولة والمدينة كموديلات
  static Future<void> saveLocationModels({
    required Country country,
    required City? city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countryKey, jsonEncode(country.toMap()));
    await prefs.setString(
      _cityKey,
      city != null ? jsonEncode(city.toMap()) : '',
    );
  }

  /// ✅ استرجاع الدولة والمدينة كموديلات
  static Future<(Country?, City?)> loadLocationModels() async {
    final prefs = await SharedPreferences.getInstance();

    final countryJson = prefs.getString(_countryKey);
    final cityJson = prefs.getString(_cityKey);

    final country =
        (countryJson != null && countryJson.isNotEmpty)
            ? Country.fromMap(jsonDecode(countryJson))
            : null;

    final city =
        (cityJson != null && cityJson.isNotEmpty)
            ? City.fromMap(jsonDecode(cityJson))
            : null;

    return (country, city);
  }

  /// ✅ مسح الدولة والمدينة من التخزين
  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_countryKey);
    await prefs.remove(_cityKey);
  }

  static Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDarkMode);
  }

  static Future<bool> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_dark_mode') ?? false;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
