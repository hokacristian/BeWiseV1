import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/presentation/page/product/product_base_page.dart';
import 'package:bewise/presentation/widgets/pagination_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final int _limit = 10;
  bool _isLoading = false;
  bool _isLoadingProduct = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Fetch histories when page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHistories(_currentPage);
    });
  }

  Future<void> _fetchHistories(int page) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      await productProvider.fetchScanHistories(page, _limit);
    } catch (e) {
      print('Error fetching histories: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Produk',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (_isLoading && productProvider.products.isEmpty) {
            return _buildSkeletonLoading();
          }

          if (productProvider.errorMessage != null) {
            return _buildErrorState(productProvider.errorMessage!);
          }

          if (productProvider.products.isEmpty) {
            return _buildEmptyState();
          }

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: _buildProductGrid(productProvider),
                  ),
                  
                  // Pagination
                  if (productProvider.totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: PaginationWidget(
                        currentPage: productProvider.currentPage,
                        totalPages: productProvider.totalPages,
                        hasNextPage: productProvider.hasNextPage,
                        hasPreviousPage: productProvider.hasPreviousPage,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                          _fetchHistories(page);
                        },
                      ),
                    ),
                ],
              ),
              
              // Loading overlay
              if (_isLoadingProduct)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(ProductProvider productProvider) {
  return GridView.builder(
    padding: const EdgeInsets.all(20),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 16,
      childAspectRatio: 0.75,
    ),
    itemCount: productProvider.products.length,
    itemBuilder: (context, index) {
      final product = productProvider.products[index];
      final history = productProvider.histories.isNotEmpty && index < productProvider.histories.length 
          ? productProvider.histories[index] 
          : null;
      
      return GestureDetector(
        onTap: () {
          if (!mounted) return;
          
          setState(() {
            _isLoadingProduct = true;
          });
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductBasePage(
                product: product,
                historyId: history?.id, // Pass history ID if available
                sourceType: 'history',
              ),
            ),
          ).then((_) {
            if (mounted) {
              setState(() {
                _isLoadingProduct = false;
              });
            }
          });
        },
        child: ProductCard(product: product),
      );
    },
  );
}

  Widget _buildSkeletonLoading() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 8, // Show 8 skeleton items
        itemBuilder: (context, index) {
          return Skeletonizer(
            enabled: true,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Gagal Memuat Riwayat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Terjadi kesalahan saat memuat data riwayat produk',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _fetchHistories(1),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Riwayat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Mulai scan produk untuk melihat riwayat di sini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Mulai Scan'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}