import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'package:bewise/core/utils/sessionmanager.dart';

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

  Future<void> initialize() async {
    final sessionManager = SessionManager();
    _token = await sessionManager.getToken();
    if (_token != null) {
      final userDetails = await sessionManager.getUserDetails();
      if (userDetails != null) {
        _user = User(
          id: userDetails['userId'],
          email: userDetails['userEmail'],
          firstName: userDetails['userFirstName'],
          lastName: userDetails['userLastName'],
          gender: userDetails['userGender'],
          avatarLink: userDetails['userAvatarLink'],
        );
      }
    }
  }

   Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.login(email, password);
      _token = response['data']['token'];
      _user = User.fromJson(response['data']['user']);

      final sessionManager = SessionManager();
      await sessionManager.saveSession(
        _token!,
        _user!.id,
        _user!.firstName,
        _user!.lastName,
        _user!.email,
        gender: _user!.gender,
        avatarLink: _user!.avatarLink,
      );

      print("Token saved: $_token");
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      print("Login error: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<void> register(String firstName, String lastName, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.register(firstName, lastName, email, password);
      _errorMessage = null;
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
    try {
      if (_token == null) {
        final sessionManager = SessionManager();
        _token = await sessionManager.getToken();
        if (_token == null) {
          throw Exception('No token found');
        }
      }

      final whoAmIResponse = await apiService.getWhoAmI(_token!);
      // whoAmIResponse di sini diasumsikan sudah didecode ke dalam model
      // Contoh: whoAmIResponse.data['user'] dan whoAmIResponse.data['subscription']
      // Di sini kita gunakan WhoAmIResponse sebagai contoh:

      _user = User(
        id: whoAmIResponse.userId,
        email: whoAmIResponse.email,
        firstName: whoAmIResponse.firstName,
        lastName: whoAmIResponse.lastName,
        gender: whoAmIResponse.gender,
        avatarLink: whoAmIResponse.avatarLink,
      );

      // Cek subscription
      final subscription = whoAmIResponse.subscription; 
      // subscription misal:
      // {
      //   "isActive": true,
      //   "planName": "Monthly",
      //   "validUntil": "2025-01-28T20:55:48.494Z"
      // }

      final sessionManager = SessionManager();
      await sessionManager.saveSession(
        _token!,
        _user!.id,
        _user!.firstName,
        _user!.lastName,
        _user!.email,
        gender: _user!.gender,
        avatarLink: _user!.avatarLink,
        isActive: subscription?.isActive,
        planName: subscription?.planName,
        validUntil: subscription?.validUntil,
      );
    } catch (error) {
      _errorMessage = error.toString();
      print("Error fetching user data: $_errorMessage");
    }
  }


 // Update Profile
  Future<void> updateProfile(String firstName, String lastName, String gender) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_token == null) throw Exception('No token found');
      final response = await apiService.updateProfile(_token!, firstName, lastName, gender);

      _user = User(
        id: _user?.id ?? 0,
        email: _user?.email ?? '',
        firstName: response['first_name'],
        lastName: response['last_name'],
        gender: response['gender'],
        avatarLink: _user?.avatarLink,
      );

      final sessionManager = SessionManager();
      await sessionManager.saveSession(
        _token!,
        _user!.id,
        _user!.firstName,
        _user!.lastName,
        _user!.email,
        gender: _user!.gender,
        avatarLink: _user!.avatarLink,
      );

      print('Profile updated: ${_user!.firstName} ${_user!.lastName}, ${_user!.gender}');
    } catch (error) {
      _errorMessage = error.toString();
      print("Error updating profile: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Avatar
  Future<void> updateAvatar(String filePath) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    if (_token == null) throw Exception('No token found');
    final response = await apiService.updateAvatar(_token!, filePath);

    // Perbarui avatar lokal
    _user = User(
  id: _user?.id ?? 0,
  email: _user?.email ?? '',
  firstName: _user?.firstName ?? '',
  lastName: _user?.lastName ?? '',
  gender: _user?.gender ?? '',
  avatarLink: response['data']['avatar_link'], // URL avatar yang baru
);


    // Simpan ke SessionManager
      final sessionManager = SessionManager();
      await sessionManager.saveSession(
        _token!,
        _user!.id,
        _user!.firstName,
        _user!.lastName,
        _user!.email,
        gender: _user!.gender,
        avatarLink: _user!.avatarLink,
      );

    print('Avatar updated: ${_user!.avatarLink}');
  } catch (error) {
    _errorMessage = error.toString();
    print("Error updating avatar: $_errorMessage");
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
