import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService apiService;
  Booking? _booking;
  Payment? _payment;
  bool _isLoading = false;
  String? _errorMessage;

  BookingProvider(this.apiService);

  Booking? get booking => _booking;
  Payment? get payment => _payment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> createBooking(String token, int subscriptionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.createBooking(token, subscriptionId);
      _booking = Booking.fromJson(response['data']['booking']);
      _payment = Payment.fromJson(response['data']['payment']);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getPaymentRedirectUrl() async {
    if (_payment == null || _payment!.redirectUrl.isEmpty) {
      throw Exception('URL pembayaran tidak tersedia');
    }
    return _payment!.redirectUrl;
  }
}

