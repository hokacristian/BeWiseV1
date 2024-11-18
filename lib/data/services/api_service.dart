import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } else {
      throw Exception(data['message'] ?? 'Failed to login');
    }
  }


  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Registration failed'); 
      }
    } else {
      throw Exception(data['message'] ?? 'Failed to register');
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Password reset failed'); 
      }
    } else {
      throw Exception(data['message'] ?? 'Failed to send reset password email');
    }
  }

  Future<User> getWhoAmI(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/whoami'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return User.fromJson(data);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}
