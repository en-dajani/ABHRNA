import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_info_model.dart';

class TripModel {
  final String? id;
  final String boatId;
  final String ownerId;
  final String city;
  final String type;
  final String title;
  final String? description;
  final DateTime time;
  final int durationHours;
  final int maxParticipants;
  final double pricePerPerson;
  final List<UserInfoModel> participants;
  final DateTime createdAt;

  TripModel({
    this.id,
    required this.boatId,
    required this.ownerId,
    required this.city,
    required this.type,
    required this.title,
    this.description,
    required this.time,
    required this.durationHours,
    required this.maxParticipants,
    required this.pricePerPerson,
    required this.participants,
    required this.createdAt,
  });

  factory TripModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return TripModel(
      id: id,
      boatId: map['boatId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      city: map['city'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      time: (map['time'] as Timestamp).toDate(),
      durationHours: map['durationHours'] ?? 1,
      maxParticipants: map['maxParticipants'] ?? 1,
      pricePerPerson: (map['pricePerPerson'] as num).toDouble(),
      participants:
          (map['participants'] as List<dynamic>?)
              ?.map((e) => UserInfoModel.fromMap(e))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'boatId': boatId,
      'ownerId': ownerId,
      'city': city,
      'type': type,
      'title': title,
      'description': description,
      'time': Timestamp.fromDate(time),
      'durationHours': durationHours,
      'maxParticipants': maxParticipants,
      'pricePerPerson': pricePerPerson,
      'participants': participants.map((p) => p.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
