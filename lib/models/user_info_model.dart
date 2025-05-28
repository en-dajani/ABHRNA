class UserInfoModel {
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;

  const UserInfoModel({
    required this.uid,
    this.name,
    this.email,
    this.photoUrl,
  });

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      uid: map['uid'] ?? '',
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'photoUrl': photoUrl};
  }

  @override
  String toString() {
    return 'UserInfoModel(uid: $uid, name: $name, email: $email, photoUrl: $photoUrl)';
  }
}
