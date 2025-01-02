class WhoAmIResponse {
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? avatarLink;

  // Tambahkan field subscription jika ingin lebih rapi
  final Subscription? subscription;

  WhoAmIResponse({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.avatarLink,
    this.subscription,
  });

  factory WhoAmIResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final userJson = data['user'] ?? {};
    final subscriptionJson = data['subscription'] ?? {};

    return WhoAmIResponse(
      userId: userJson['id'] ?? 0,
      email: userJson['email'] ?? 'Unknown email',
      firstName: userJson['first_name'] ?? 'Unknown',
      lastName: userJson['last_name'] ?? 'Unknown',
      gender: userJson['gender'],
      avatarLink: userJson['avatar_link'],
      subscription: Subscription.fromJson(subscriptionJson),
    );
  }
}

// Contoh model Subscription
class Subscription {
  final bool isActive;
  final String planName;
  final String validUntil;

  Subscription({
    required this.isActive,
    required this.planName,
    required this.validUntil,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      isActive: json['isActive'] ?? false,
      planName: json['planName'] ?? '',
      validUntil: json['validUntil'] ?? '',
    );
  }
}