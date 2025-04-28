import 'package:bewise/data/models/user_model.dart';
class WhoAmIResponse {
  final User user;
  final Subscription? subscription;

  WhoAmIResponse({
    required this.user,
    this.subscription,
  });

  factory WhoAmIResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    final subscriptionJson = json['subscription'] as Map<String, dynamic>?;

    return WhoAmIResponse(
      user: User.fromJson(userJson),
      subscription: subscriptionJson != null ? Subscription.fromJson(subscriptionJson) : null,
    );
  }
}


class Subscription {
  final bool isActive;
  final String planName;
  final String validUntil;
  final String countDownDay;

  Subscription({
    required this.isActive,
    required this.planName,
    required this.validUntil,
    required this.countDownDay,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      isActive: json['isActive'] ?? false,
      planName: json['planName'] ?? '',
      validUntil: json['validUntil'] ?? '',
      countDownDay: json['countDownDay'] ?? '',
    );
  }
}