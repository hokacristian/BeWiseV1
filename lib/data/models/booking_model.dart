class Booking {
  final int id;
  final int userId;
  final int subscriptionId;
  final String startDate;
  final String endDate;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      subscriptionId: json['subscription_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
    );
  }
}

class Payment {
  final String token;
  final String redirectUrl;

  Payment({
    required this.token,
    required this.redirectUrl,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      token: json['token'] ?? '',
      redirectUrl: json['redirect_url'] ?? '',
    );
  }
}
