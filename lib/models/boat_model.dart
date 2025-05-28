import 'package:abhrna/models/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:abhrna/models/enums/trip_type.dart';

class BoatModel {
  final String id;
  final String name;
  final String? description;
  final List<TripType> tripTypes;
  final String ownerId;
  final int capacity;
  final double pricePerHour;
  final List<String> images;
  final Address? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BoatModel({
    required this.id,
    required this.name,
    this.description,
    required this.tripTypes,
    required this.ownerId,
    required this.capacity,
    required this.pricePerHour,
    required this.images,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory BoatModel.fromMap(Map<String, dynamic> map) => BoatModel(
    id: map['id'],
    name: map['name'] ?? '',
    description: map['description'],
    tripTypes: TripType.listFromStrings(
      List<String>.from(map['tripTypes'] ?? []),
    ),
    ownerId: map['ownerId'] ?? '',
    capacity: map['capacity'] ?? 0,
    pricePerHour: (map['pricePerHour'] ?? 0).toDouble(),
    images: List<String>.from(map['images'] ?? []),
    address:
        map['address'] != null
            ? Address.fromMap(Map<String, dynamic>.from(map['address']))
            : null,
    createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
  );

  Map<String, dynamic> toMap({bool forUpdate = false}) => {
    'id': id,
    'name': name,
    if (description != null) 'description': description,
    'tripTypes': TripType.listToStrings(tripTypes),
    'ownerId': ownerId,
    'capacity': capacity,
    'pricePerHour': pricePerHour,
    'images': images,
    if (address != null) 'address': address!.toMap(),
    if (!forUpdate) 'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
