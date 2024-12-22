import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';
  static const String _userFirstNameKey = 'user_first_name';
  static const String _userLastNameKey = 'user_last_name';
  static const String _userEmailKey = 'user_email';
  static const String _userGenderKey = 'user_gender';
  static const String _userAvatarLinkKey = 'user_avatar_link';

  Future<void> saveSession(
    String token,
    int userId,
    String firstName,
    String lastName,
    String userEmail, {
    String? gender,
    String? avatarLink,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userFirstNameKey, firstName);
    await prefs.setString(_userLastNameKey, lastName);
    await prefs.setString(_userEmailKey, userEmail);
    if (gender != null) {
      await prefs.setString(_userGenderKey, gender);
    }
    if (avatarLink != null) {
      await prefs.setString(_userAvatarLinkKey, avatarLink);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_userIdKey)) return null;

    return {
      'userId': prefs.getInt(_userIdKey),
      'userFirstName': prefs.getString(_userFirstNameKey),
      'userLastName': prefs.getString(_userLastNameKey),
      'userEmail': prefs.getString(_userEmailKey),
      'userGender': prefs.getString(_userGenderKey),
      'userAvatarLink': prefs.getString(_userAvatarLinkKey),
    };
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
