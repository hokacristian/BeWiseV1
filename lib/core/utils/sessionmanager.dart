import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userGenderKey = 'user_gender';
  static const String _userAvatarLinkKey = 'user_avatar_link';

  // Save session
   Future<void> saveSession(
    String token,
    int userId,
    String userName,
    String userEmail, {
    String? gender,
    String? avatarLink,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userNameKey, userName);
    await prefs.setString(_userEmailKey, userEmail);
    if (gender != null) {
      await prefs.setString(_userGenderKey, gender);
    }
    if (avatarLink != null) {
      await prefs.setString(_userAvatarLinkKey, avatarLink);
    }
  }

  // Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get user details
   Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_userIdKey)) return null;

    return {
      'userId': prefs.getInt(_userIdKey),
      'userName': prefs.getString(_userNameKey),
      'userEmail': prefs.getString(_userEmailKey),
      'userGender': prefs.getString(_userGenderKey),
      'userAvatarLink': prefs.getString(_userAvatarLinkKey),
    };
  }

  // Clear session
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
