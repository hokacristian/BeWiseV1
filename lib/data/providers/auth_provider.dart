import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  User? _user;
  String? _token;

  bool _isLoading = false; 
  String? _errorMessage; 

  AuthProvider(this.apiService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  User? get user => _user;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.login(email, password);
      _token = response['data']['token'];
      _user = User.fromJson(response['data']['user']);
    } catch (error) {
    _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
  }
}

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await apiService.register(name, email, password);
    } catch (error) {
    _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await apiService.forgotPassword(email);
    } catch (error) {
    _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_token == null) throw Exception('No token found');
      _user = await apiService.getWhoAmI(_token!);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}
