import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/presentation/page/product/product_base_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<void> _fetchHistoriesFuture;
  final int _limit = 10; // Items per page

  @override
  void initState() {
    super.initState();
    _fetchHistoriesFuture = _fetchHistories(1); // Start with page 1
  }

  Future<void> _fetchHistories(int page) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchScanHistories(page, _limit);
  }

  void _navigateToPage(int page) {
    setState(() {
      _fetchHistoriesFuture = _fetchHistories(page);
    });
  }

  Future<void> _onRefresh() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return _fetchHistories(productProvider.currentPage);
  }

  

  Widget _buildPageButton(int page, int currentPage) {
    bool isSelected = page == currentPage;
    
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: Colors.white,
          textStyle: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onPressed: () => _navigateToPage(page),
        child: Text('$page'),
      ),
    );
  }

  List<Widget> _buildPageNumbers(int currentPage, int totalPages) {
    List<Widget> pageNumbers = [];
    
    // Always show page 1
    pageNumbers.add(_buildPageButton(1, currentPage));
    
    // Show current page and surrounding pages
    int startPage = currentPage - 1 > 2 ? currentPage - 1 : 2;
    int endPage = currentPage + 1 < totalPages - 1 ? currentPage + 1 : totalPages - 1;
    
    // Add ellipsis if needed
    if (startPage > 2) {
      pageNumbers.add(const Text('...', style: TextStyle(color: Colors.white)));
    }
    
    // Add middle page numbers
    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(_buildPageButton(i, currentPage));
    }
    
    // Add ellipsis if needed
    if (endPage < totalPages - 1) {
      pageNumbers.add(const Text('...', style: TextStyle(color: Colors.white)));
    }
    
    // Always show last page if there are multiple pages
    if (totalPages > 1) {
      pageNumbers.add(_buildPageButton(totalPages, currentPage));
    }
    
    return pageNumbers;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Produk'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<void>(
          future: _fetchHistoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && 
                productProvider.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Gagal memuat riwayat: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (productProvider.products.isEmpty) {
              return const Center(
                child: Text('Belum ada riwayat produk'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductBasePage(product: product),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
                if (productProvider.isLoading && productProvider.products.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                Container(
                  color: const Color(0xFFF5A9BC), // Pink color as shown in the image
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: productProvider.hasPreviousPage 
                          ? () => _navigateToPage(productProvider.currentPage - 1) 
                          : null,
                        child: const Text('Previous'),
                      ),
                      ..._buildPageNumbers(
                        productProvider.currentPage, 
                        productProvider.totalPages
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: productProvider.hasNextPage 
                          ? () => _navigateToPage(productProvider.currentPage + 1) 
                          : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}