import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:bewise/data/response/whoami_response.dart';
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

  // Parsing response body
  final data = jsonDecode(response.body);

  if (response.statusCode == 201) { // Menggunakan status code 201 sebagai tanda sukses
    if (data['status'] == true) {
      return data; // Kembalikan data jika berhasil
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

Future<WhoAmIResponse> getWhoAmI(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/whoami'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'];
    return WhoAmIResponse.fromJson(data);
  } else {
    throw Exception('Failed to fetch user data');
  }
}

 Future<Map<String, dynamic>> updateProfile(String token, String name, String gender) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "gender": gender,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to update profile');
      }
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  // Update Avatar
  Future<Map<String, dynamic>> updateAvatar(String token, String filePath) async {
  try {
    final request = http.MultipartRequest(
      'PATCH', // Gunakan PATCH sesuai dengan endpoint
      Uri.parse('$baseUrl/avatar-profile'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json'; // Tambahkan Accept header
    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar', // Key sesuai dengan yang diharapkan API
        filePath,
        contentType: MediaType('image', 'jpeg'), // Pastikan tipe sesuai
      ),
    );

    // Kirim request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      if (data['status'] == true) {
        print('Avatar updated successfully: ${data['data']['avatar_link']}');
        return data;
      } else {
        print('Error updating avatar: ${data['message']}');
        throw Exception(data['message']);
      }
    } else {
      print('Failed to update avatar. Status code: ${response.statusCode}');
      print('Response body: $responseBody');
      throw Exception('Failed to update avatar');
    }
  } catch (e) {
    print('Error occurred while updating avatar: $e');
    throw Exception('Error updating avatar: $e');
  }
}


}
