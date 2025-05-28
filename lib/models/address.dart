import 'package:abhrna/models/city.dart';
import 'package:abhrna/models/country.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final Country country;
  final City city;
  final GeoPoint? location;

  Address({required this.country, required this.city, this.location});

  factory Address.fromMap(Map<String, dynamic> map) => Address(
    country: Country.fromMap(Map<String, dynamic>.from(map['country'] ?? {})),
    city: City.fromMap(Map<String, dynamic>.from(map['city'] ?? {})),
    location: map['location'] != null ? map['location'] as GeoPoint : null,
  );

  Map<String, dynamic> toMap() => {
    'country': country.toMap(),
    'city': city.toMap(),
    if (location != null) 'location': location,
  };
}
