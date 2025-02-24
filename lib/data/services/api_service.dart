import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:bewise/data/response/whoami_response.dart';
import 'package:bewise/data/models/product_model.dart';

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


  Future<Map<String, dynamic>> register(String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"first_name": firstName, "last_name": lastName, "email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (data['status'] == true) {
        return data['data']['user'];
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

 Future<Map<String, dynamic>> updateProfile(String token, String firstName, String lastName, String gender) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data['data'];
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

 Future<Product> getProductById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['product'];
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

 Future<List<Map<String, dynamic>>> getProductsByCategory(int categoryId, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/products/category/$categoryId'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['data']['products']);
  } else {
    throw Exception('Failed to load products');
  }
}

  Future<List<Product>> searchProducts(String name, int page, int limit, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?name=$name&page=$page&limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['products'] as List;
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  Future<Product> scanProduct(String barcode, String token) async {
  final response = await http.post(
    Uri.parse('$baseUrl/products/scan'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'barcode': barcode}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'];
    
    // Pisahkan product dan rekomendasi
    Product product = Product.fromJson(data['product']);
    List<Product> rekomendasi = (data['rekomendasi'] as List)
        .map((item) => Product.fromJson(item))
        .toList();
    
    // Assign rekomendasi ke dalam objek product
    product = product.copyWith(rekomendasi: rekomendasi);
    
    print('Rekomendasi Produk (ApiService): ${rekomendasi.length}');
    
    return product;
  } else {
    throw Exception('Failed to scan product');
  }
}





  Future<List<Map<String, dynamic>>> getHistories(int page, int limit, String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/histories?page=$page&limit=$limit'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Histories fetched: ${data['data']['histories']}'); // Debug log
    return List<Map<String, dynamic>>.from(data['data']['histories']);
  } else {
    print('Error fetching histories: ${response.statusCode} ${response.body}'); // Debug log
    throw Exception('Failed to load histories');
  }
}

  Future<Map<String, dynamic>> getHistoryById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/histories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load history with id $id');
    }
  }

  Future<void> deleteHistory(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/histories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (!data['status']) {
        throw Exception('Failed to delete history: ${data['message']}');
      }
    } else {
      throw Exception('Failed to delete history with id $id');
    }
  }

  Future<List<Product>> fetchHistoriesAsProducts(int page, int limit, String token) async {
  final historiesResponse = await getHistories(page, limit, token);
  
  // Ambil semua product_id dari histories
  final productIds = historiesResponse.map<int>((history) => history['product_id']).toSet();

  // Ambil detail setiap produk berdasarkan product_id
  final List<Product> products = await Future.wait(productIds.map((id) async {
    try {
      return await getProductById(id, token);
    } catch (e) {
      // Jika ada error, kembalikan produk default
      return Product(
        id: id,
        name: 'Unknown Product',
        brand: 'Unknown',
        photo: '',
        categoryProductId: 0,
        nutritionFactId: 0,
        barcode: '',
        priceA: 0,  // Default priceA
        priceB: 0,  // Default priceB
        labelId: 0,
      );
    }
  }).toList());

  return products;
}

Future<List<Product>> getTopChoices(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/top-choices'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to fetch top choices');
    }
  }

Future<Map<String, dynamic>> createBooking(String token, int subscriptionId) async {
  final response = await http.post(
    Uri.parse('$baseUrl/subscriptions/booking'), // Pastikan endpoint sesuai
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "subscriptionId": subscriptionId, // Body JSON
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body); // Decode response
    if (data['status'] == true) {
      return data; // Return data jika status sukses
    } else {
      throw Exception(data['message'] ?? 'Failed to create booking');
    }
  } else {
    throw Exception('Failed to create booking: ${response.body}');
  }
}


}


