import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/page/product/detail_page.dart';
import 'package:bewise/presentation/page/product/recommendation_page.dart';
import 'package:bewise/presentation/widgets/product_image.dart';

class ProductBasePage extends StatefulWidget {
  final Product product;
  final int? historyId; // New parameter for history ID
  final String sourceType; // 'scan' or 'history'

  const ProductBasePage({
    required this.product, 
    this.historyId,
    this.sourceType = 'scan', // Default to scan
    Key? key
  }) : super(key: key);

  @override
  State<ProductBasePage> createState() => _ProductBasePageState();
}

class _ProductBasePageState extends State<ProductBasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Product? _completeProduct;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch complete product data if coming from history or if nutrition data is missing
    if (widget.sourceType == 'history' || widget.product.nutritionFact == null) {
      _fetchCompleteProductData();
    } else {
      _completeProduct = widget.product;
    }
  }

  Future<void> _fetchCompleteProductData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      await productProvider.fetchProductById(widget.product.id);
      
      if (productProvider.product != null) {
        setState(() {
          _completeProduct = productProvider.product;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat detail produk';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchCompleteProductData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final Product product = _completeProduct ?? widget.product;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              ProductImage(imageUrl: product.photo, label: product.label),
            ],
          ),

          // TabBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicator: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: 'Detail'),
                    Tab(text: 'Rekomendasi Produk'),
                  ],
                ),
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Detail Tab
                DetailPage(product: product),
                // Recommendation Tab - Pass the source information
                RecommendationPage(
                  product: widget.sourceType == 'scan' ? product : null,
                  historyId: widget.historyId,
                  sourceType: widget.sourceType,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}