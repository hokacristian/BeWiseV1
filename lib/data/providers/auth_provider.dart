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

  AuthProvider(this.apiService) {
    _initialize();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  User? get user => _user;
  String? get token => _token;

  Future<void> _initialize() async {
    final sessionManager = SessionManager();
    _token = await sessionManager.getToken();
    if (_token != null) {
      final userDetails = await sessionManager.getUserDetails();
      if (userDetails != null) {
        _user = User(
          id: userDetails['userId'],
          email: userDetails['userEmail'],
          name: userDetails['userName'],
          gender: userDetails['userGender'],
          avatarLink: userDetails['userAvatarLink'],
        );
      }
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await apiService.login(email, password);
    _token = response['data']['token'];
    _user = User.fromJson(response['data']['user']);

    // Simpan sesi
    final sessionManager = SessionManager();
    await sessionManager.saveSession(
      _token!,
      _user!.id,
      _user!.name,
      _user!.email,
      gender: _user!.gender,
      avatarLink: _user!.avatarLink,
    );

    print("Token saved: $_token"); // Debugging
  } catch (error) {
    _errorMessage = error.toString().replaceFirst('Exception: ', '');
    print("Login error: $_errorMessage"); // Debugging
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
    final response = await apiService.register(name, email, password);

    // Jika respons sukses (200), kosongkan pesan error
    _errorMessage = null;

    // Logika untuk navigasi dilakukan di UI, bukan di sini
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
    if (_token == null) {
      final sessionManager = SessionManager();
      _token = await sessionManager.getToken();
      if (_token == null) {
        throw Exception('No token found');
      }
    }

    final whoAmIResponse = await apiService.getWhoAmI(_token!);
    _user = User(
      id: whoAmIResponse.userId,
      email: whoAmIResponse.email,
      name: whoAmIResponse.name,
      gender: whoAmIResponse.gender,
      avatarLink: whoAmIResponse.avatarLink,
    );

    // Simpan data pengguna ke SessionManager
    final sessionManager = SessionManager(); // Buat instance
await sessionManager.saveSession(
  _token!,
  _user!.id,
  _user!.name,
  _user!.email,
  gender: _user!.gender,
  avatarLink: _user!.avatarLink,
);


    print("User data fetched: ${_user?.name}");
  } catch (error) {
    _errorMessage = error.toString();
    print("Error fetching user data: $_errorMessage");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

 // Update Profile
  Future<void> updateProfile(String name, String gender) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_token == null) throw Exception('No token found');
      final response = await apiService.updateProfile(_token!, name, gender);

      // Perbarui data user lokal
      _user = User(
        id: _user?.id ?? 0,
        email: _user?.email ?? '',
        name: response['data']['name'],
        gender: response['data']['gender'],
        avatarLink: _user?.avatarLink,
      );

      // Simpan ke SessionManager
      final sessionManager = SessionManager();
      await sessionManager.saveSession(
        _token!,
        _user!.id,
        _user!.name,
        _user!.email,
        gender: _user!.gender,
        avatarLink: _user!.avatarLink,
      );

      print('Profile updated: ${_user!.name}, ${_user!.gender}');
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
      name: _user?.name ?? '',
      gender: _user?.gender ?? '',
      avatarLink: response['data']['avatar_link'], // URL avatar yang baru
    );

    // Simpan ke SessionManager
    final sessionManager = SessionManager();
    await sessionManager.saveSession(
      _token!,
      _user!.id,
      _user!.name,
      _user!.email,
      gender: _user!.gender,
      avatarLink: _user!.avatarLink, // Simpan URL avatar baru
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
