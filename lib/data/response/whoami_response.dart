class WhoAmIResponse {
  final int userId;
  final String email;
  final String name;
  final String? gender;
  final String? avatarLink;

  WhoAmIResponse({
    required this.userId,
    required this.email,
    required this.name,
    this.gender,
    this.avatarLink,
  });

  factory WhoAmIResponse.fromJson(Map<String, dynamic> json) {
    return WhoAmIResponse(
      userId: json['id'] ?? 0,
      email: json['email'] ?? 'Unknown email',
      name: json['name'] ?? 'Unknown name',
      gender: json['gender'], // Tetap null jika tidak ada
      avatarLink: json['avatar_link'], // Tetap null jika tidak ada
    );
  }
}
