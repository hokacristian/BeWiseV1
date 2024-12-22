class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? avatarLink;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.avatarLink,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      avatarLink: json['avatar_link'],
    );
  }
}