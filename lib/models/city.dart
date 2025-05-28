class City {
  final String id;
  final Map<String, String> name;
  final String countryId;

  City({required this.id, required this.name, required this.countryId});

  factory City.fromMap(Map<String, dynamic> map) => City(
    id: map['id'],
    name: Map<String, String>.from(map['name']),
    countryId: map['countryId'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'countryId': countryId,
  };
}
