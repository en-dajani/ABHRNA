import 'package:abhrna/models/city.dart';
import 'package:abhrna/models/country.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  List<Country> countries = [];
  List<City> cities = [];
  List<City> _allCities = [];

  bool _loading = false;
  bool get isLoading => _loading;

  /// تحميل جميع الدول والمدن
  Future<void> loadLocation({String locale = 'en'}) async {
    _loading = true;
    notifyListeners();

    // تحميل الدول
    final countrySnapshot = await _firestore.collection('countries').get();
    countries =
        countrySnapshot.docs.map((doc) {
          final name = Map<String, dynamic>.from(doc['name']);
          return Country(
            id: doc.id,
            flag: doc['flag'],
            name: name.map((key, value) => MapEntry(key, value.toString())),
          );
        }).toList();

    // ✅ ترتيب الدول حسب اللغة
    countries.sort((a, b) {
      final nameA = (a.name[locale] ?? a.name['en'] ?? '').toLowerCase();
      final nameB = (b.name[locale] ?? b.name['en'] ?? '').toLowerCase();
      return nameA.compareTo(nameB);
    });

    // تحميل كل المدن مرة وحدة
    final citySnapshot = await _firestore.collection('cities').get();
    _allCities =
        citySnapshot.docs.map((doc) {
          final name = Map<String, dynamic>.from(doc['name']);
          return City(
            id: doc.id,
            name: name.map((key, value) => MapEntry(key, value.toString())),
            countryId: doc['countryId'],
          );
        }).toList();

    _loading = false;
    notifyListeners();
  }

  /// فلترة وترتيب المدن بناءً على الدولة
  Future<void> loadCities(String countryId, {String locale = 'en'}) async {
    final filtered = _allCities.where((c) => c.countryId == countryId).toList();

    filtered.sort((a, b) {
      final nameA = (a.name[locale] ?? a.name['en'] ?? '').toLowerCase();
      final nameB = (b.name[locale] ?? b.name['en'] ?? '').toLowerCase();
      return nameA.compareTo(nameB);
    });

    cities = filtered;
    notifyListeners();
  }
}
