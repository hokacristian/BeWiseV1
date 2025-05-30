import 'package:shared_preferences/shared_preferences.dart';
import 'package:bewise/data/services/api_service.dart';

class SessionManager {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';
  static const String _userFirstNameKey = 'user_first_name';
  static const String _userLastNameKey = 'user_last_name';
  static const String _userEmailKey = 'user_email';
  static const String _userGenderKey = 'user_gender';
  static const String _userAvatarLinkKey = 'user_avatar_link';
  static const String _subIsActiveKey = 'subscription_is_active';
  static const String _subPlanNameKey = 'subscription_plan_name';
  static const String _subValidUntilKey = 'subscription_valid_until';
  static const String _subCountDownDayKey = 'subscription_count_down_day';

  final ApiService _apiService = ApiService();

  /// Menyimpan session user + subscription (opsional).
  /// Jika subscription tidak disertakan, bisa diabaikan.
  Future<void> saveSession(
    String token,
    int userId,
    String firstName,
    String lastName,
    String userEmail, {
    String? gender,
    String? avatarLink,
    bool? isActive,
    String? planName,
    String? validUntil,
    String? countDownDay,

  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userFirstNameKey, firstName);
    await prefs.setString(_userLastNameKey, lastName);
    await prefs.setString(_userEmailKey, userEmail);

    if (gender != null) await prefs.setString(_userGenderKey, gender);
    if (avatarLink != null) await prefs.setString(_userAvatarLinkKey, avatarLink);
    if (isActive != null) await prefs.setBool(_subIsActiveKey, isActive);
    if (planName != null) await prefs.setString(_subPlanNameKey, planName);
    if (validUntil != null) await prefs.setString(_subValidUntilKey, validUntil);
    if (countDownDay != null) await prefs.setString(_subCountDownDayKey, countDownDay);
  }

  /// Mendapatkan token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Mendapatkan detail user & subscription
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
      'subscriptionIsActive': prefs.getBool(_subIsActiveKey),
      'subscriptionPlanName': prefs.getString(_subPlanNameKey),
      'subscriptionValidUntil': prefs.getString(_subValidUntilKey),
      'subscriptionCountDownDay': prefs.getString(_subCountDownDayKey),
    };
  }

  /// Menghapus semua session
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Verifikasi validitas token
  Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return false;
      }
      
      // Coba mendapatkan data user untuk memverifikasi token
      await _apiService.getWhoAmI(token);
      return true;
    } catch (e) {
      // Token tidak valid jika request whoami gagal
      print('Token tidak valid: $e');
      await clearSession(); // Clear session jika token tidak valid
      return false;
    }
  }

  /// Mengecek apakah sudah login dengan valid
  Future<bool> isLoggedIn() async {
    return await isTokenValid();
  }
}