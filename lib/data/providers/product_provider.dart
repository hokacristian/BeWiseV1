import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/data/services/api_service.dart';
import 'package:bewise/core/utils/sessionmanager.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService apiService;

  ProductProvider({required this.apiService}) {
    _initializeToken();
  }

  List<Product> _topChoices = [];
  bool _isLoadingTopChoices = false;
  String? _errorMessageTopChoices;

  List<Product> get topChoices => _topChoices;
  bool get isLoadingTopChoices => _isLoadingTopChoices;
  String? get errorMessageTopChoices => _errorMessageTopChoices;

  Future<void> fetchTopChoices() async {
    _isLoadingTopChoices = true;
    _errorMessageTopChoices = null;
    notifyListeners();

    try {
      final sessionManager = SessionManager();
      final token = await sessionManager.getToken();
      if (token == null) throw Exception('Token is not available');

      _topChoices = await apiService.getTopChoices(token);
    } catch (error) {
      _errorMessageTopChoices = error.toString();
    } finally {
      _isLoadingTopChoices = false;
      notifyListeners();
    }
  }

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

  // Initialize token from session
  Future<void> _initializeToken() async {
    final sessionManager = SessionManager();
    token = await sessionManager.getToken();
    notifyListeners();
  }

  // Fetch product by ID
  Future<void> fetchProductById(int id) async {
    try {
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }
      final result = await apiService.getProductById(id, token!);
      _product = Product.fromJson(result.toJson());
    } catch (error) {
      _errorMessage = error.toString();
    }
  }

  // Fetch products by category
  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }
      final results =
          await apiService.getProductsByCategory(categoryId, token!);
      _products =
          results.map<Product>((json) => Product.fromJson(json)).toList();
      print('Fetched products: ${_products.length}');
    } catch (error) {
      _errorMessage = error.toString();
      print('Error fetching products by category: $error');
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
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }
      final results =
          await apiService.searchProducts(name, page, limit, token!);

      // Explicitly cast each item to Map<String, dynamic>
      _products = (results as List)
          .map<Product>(
              (json) => Product.fromJson(json as Map<String, dynamic>))
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
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }

      final result = await apiService.scanProduct(barcode, token!);

      _product = result;

      print('Rekomendasi Produk (Provider): ${_product?.rekomendasi?.length}');
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch scan histories
Future<void> fetchScanHistories(int page, int limit) async {
  _isLoading = true;
  _errorMessage = null;

  try {
    if (token == null) {
      await _initializeToken();
      if (token == null) throw Exception('Token is not available');
    }

    final historiesResponse = await apiService.getHistories(page, limit, token!);

    // Debug: Print raw response
    print('Histories Response: $historiesResponse');

    final List<Product> products = [];
    for (var history in historiesResponse) {
      final productData = history['product'];
      if (productData != null) {
        // Debug: Print product data before parsing
        print('Product Data: $productData');
        products.add(Product.fromJson(productData));
      } else {
        print('Product data is missing in history: $history');
      }
    }

    _products = products;
  } catch (error) {
    _errorMessage = error.toString();
    print('Error fetching histories: $error');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  // Set token for API requests (optional if manual update is needed)
  Future<void> setToken(String newToken) async {
    final sessionManager = SessionManager();
    await sessionManager.saveSession(newToken, 0, '', '', '',
        gender: null, avatarLink: null);
    token = newToken;
    notifyListeners();
  }
}
