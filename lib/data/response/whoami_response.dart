class WhoAmIResponse {
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? avatarLink;

  WhoAmIResponse({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.avatarLink,
  });

  factory WhoAmIResponse.fromJson(Map<String, dynamic> json) {
    return WhoAmIResponse(
      userId: json['id'] ?? 0,
      email: json['email'] ?? 'Unknown email',
      firstName: json['first_name'] ?? 'Unknown',
      lastName: json['last_name'] ?? 'Unknown',
      gender: json['gender'],
      avatarLink: json['avatar_link'],
    );
  }
}