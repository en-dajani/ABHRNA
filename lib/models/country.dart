class Country {
  final String id;
  final Map<String, String> name;
  final String? flag;

  Country({required this.id, required this.name, this.flag});

  factory Country.fromMap(Map<String, dynamic> map) => Country(
    id: map['id'],
    name: Map<String, String>.from(map['name']),
    flag: map['flag'],
  );

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'flag': flag};
}
