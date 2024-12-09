import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/data/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService apiService;

  ProductProvider({required this.apiService});
  
   // State management variables
  List<Product> _products = [];
  Product? _product;
  bool _isLoading = false;
  String? _errorMessage;
  String? token;

  // Getters for state
  List<Product> get products => _products;
  Product? get product => _product;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch product by ID
  Future<void> fetchProductById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (token == null) throw Exception('Token is not available');
      final result = await apiService.getProductById(id, token!);
      _product = Product.fromJson(result.toJson());
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   // Fetch products by category
  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (token == null) throw Exception('Token is not available');
      final results = await apiService.getProductsByCategory(categoryId, token!);
      _products = results.map<Product>((json) => Product.fromJson(json)).toList();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search products
  Future<void> searchProducts(String name, int page, int limit) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    if (token == null) throw Exception('Token is not available');
    final results = await apiService.searchProducts(name, page, limit, token!);

    // Explicitly cast each item to Map<String, dynamic>
    _products = (results as List)
        .map<Product>((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (error) {
    _errorMessage = error.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  // Scan product by barcode
  Future<void> scanProduct(String barcode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (token == null) throw Exception('Token is not available');
      final result = await apiService.scanProduct(barcode, token!);
      _product = Product.fromJson(result.toJson());
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
