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

  /// Method untuk pindah ke halaman berikutnya
  void _nextPage() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (productProvider.hasNextPage) {
      int nextPage = productProvider.currentPage + 1;
      setState(() {
        _fetchHistoriesFuture = _fetchHistories(nextPage);
      });
    }
  }

  /// Method untuk kembali ke halaman sebelumnya
  void _previousPage() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (productProvider.hasPreviousPage) {
      int prevPage = productProvider.currentPage - 1;
      setState(() {
        _fetchHistoriesFuture = _fetchHistories(prevPage);
      });
    }
  }

  /// Method untuk menarik data ulang (RefreshIndicator)
  Future<void> _onRefresh() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return _fetchHistories(productProvider.currentPage);
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
            // Tampilkan loading state saat awal fetch
            if (snapshot.connectionState == ConnectionState.waiting && 
                productProvider.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // Tampilkan error jika ada
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

            // Jika data berhasil di-load tapi kosong
            if (productProvider.products.isEmpty) {
              return const Center(
                child: Text('Belum ada riwayat produk'),
              );
            }

            return Column(
              children: [
                // List riwayat
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: productProvider.products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductBasePage(product: product),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
                // Show loading indicator when loading more data
                if (productProvider.isLoading && productProvider.products.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                // Pagination controls
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: productProvider.hasPreviousPage ? _previousPage : null,
                        child: const Text('Previous'),
                      ),
                      const SizedBox(width: 16),
                      Text('Page ${productProvider.currentPage} of ${productProvider.totalPages}'),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: productProvider.hasNextPage ? _nextPage : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
                // Show total items info
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}