class User {
  final int id;
  final String email;
  final String name;
  final String? gender;
  final String? avatarLink;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.gender,
    this.avatarLink,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      gender: json['gender'],
      avatarLink: json['avatar_link'],
    );
  }
}
