import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/data/services/api_service.dart';
import 'package:bewise/core/utils/sessionmanager.dart';
import 'package:bewise/data/models/history_model.dart';

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

  List<History> _histories = [];
  List<History> get histories => _histories;
  
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _hasPreviousPage;

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

  List<Product> _historyRecommendations = [];
  bool _isLoadingHistoryRecommendations = false;
  String? _errorMessageHistoryRecommendations;

  List<Product> get historyRecommendations => _historyRecommendations;
  bool get isLoadingHistoryRecommendations => _isLoadingHistoryRecommendations;
  String? get errorMessageHistoryRecommendations =>
      _errorMessageHistoryRecommendations;

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
      _product =
          result; // Use the complete Product object returned by apiService
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  // Fetch products by category with pagination
  Future<void> fetchProductsByCategory(int categoryId, int page) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }

      // Make the API call to fetch products by category and pagination data
      final results = await apiService.getProductsByCategory(
          categoryId, page, token!); // Pass token as the third argument

      // Parse products
      _products = List<Product>.from(
          results['data'].map((json) => Product.fromJson(json)));

      // Parse pagination values
      _currentPage = results['pagination']['currentPage'] ?? 1;
      _totalPages = results['pagination']['totalPages'] ?? 1;
      _hasNextPage = results['pagination']['hasNextPage'] == true;
      _hasPreviousPage = results['pagination']['hasPreviousPage'] == true;
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
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }

      // Langsung assign hasil dari API service
      final results =
          await apiService.searchProducts(name, page, limit, token!);
      _products = results;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistoryRecommendation(int historyId) async {
    _isLoadingHistoryRecommendations = true;
    _errorMessageHistoryRecommendations = null;
    notifyListeners();

    try {
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }

      _historyRecommendations =
          await apiService.getHistoryRecommendation(historyId, token!);
      print(
          'History recommendations fetched: ${_historyRecommendations.length}');
    } catch (error) {
      _errorMessageHistoryRecommendations = error.toString();
      print('Error fetching history recommendations: $error');
    } finally {
      _isLoadingHistoryRecommendations = false;
      notifyListeners();
    }
  }

// Clear history recommendations when needed
  void clearHistoryRecommendations() {
    _historyRecommendations = [];
    _isLoadingHistoryRecommendations = false;
    _errorMessageHistoryRecommendations = null;
    notifyListeners();
  }

  // Scan product by barcode
  Future<void> scanProduct(String barcode) async {
  _isLoading = true;
  _errorMessage = null;
  _product = null; 
  notifyListeners();

  try {
    if (token == null) {
      await _initializeToken();
      if (token == null) throw Exception('Token is not available');
    }

    final result = await apiService.scanProduct(barcode, token!);
    _product = result;

    print('Rekomendasi Produk (Provider): ${_product?.rekomendasi?.length}');
  } catch (error) {
    _errorMessage = error.toString();
    _product = null; // 🔥 PENTING: Clear product jika ada error
    print('Error scanning product: $_errorMessage');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

// Update method fetchScanHistories:
  Future<void> fetchScanHistories(int page, int limit) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }

      final response = await apiService.getHistories(page, limit, token!);

      // Extract histories and pagination data
      final historiesResponse = response['data'];
      final paginationData = response['pagination'];

      // Update pagination metadata
      _totalPages = paginationData['totalPage'];
      _currentPage = paginationData['currentPage'];
      _hasNextPage = paginationData['hasNextPage'];
      _hasPreviousPage = paginationData['hasPreviousPage'];

      // Parse histories as History objects
      final List<History> historyList = [];
      final List<Product> productList = [];

      for (var historyData in historiesResponse) {
        final history = History.fromJson(historyData);
        historyList.add(history);
        productList.add(history.product);
      }

      _histories = historyList;
      _products = productList; // Keep existing products list for compatibility

      print('✅ Successfully fetched ${_histories.length} histories');
    } catch (error) {
      _errorMessage = error.toString();
      print('Error fetching histories: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (token == null) {
        await _initializeToken();
        if (token == null) throw Exception('Token is not available');
      }

      // Directly fetch products without dealing with pagination
      _products = await apiService.getAllProducts(token!);
      print('✅ Successfully fetched ${_products.length} products');
    } catch (error) {
      _errorMessage = 'Failed to load all products: $error';
      print('❌ Error fetching all products: $error');
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
