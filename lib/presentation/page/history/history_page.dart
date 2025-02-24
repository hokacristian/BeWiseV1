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
  int _currentPage = 1;
  final int _limit = 5; // Jumlah item per halaman

  @override
  void initState() {
    super.initState();
    _fetchHistoriesFuture = _fetchHistories(_currentPage);
  }

  Future<void> _fetchHistories(int page) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchScanHistories(page, _limit);
  }

  /// Method untuk pindah ke halaman berikutnya
  void _nextPage() {
    setState(() {
      _currentPage++;
      _fetchHistoriesFuture = _fetchHistories(_currentPage);
    });
  }

  /// Method untuk kembali ke halaman sebelumnya
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _fetchHistoriesFuture = _fetchHistories(_currentPage);
      });
    }
  }

  /// Method untuk menarik data ulang (RefreshIndicator)
  Future<void> _onRefresh() async {
    await _fetchHistories(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Produk'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<void>(
          future: _fetchHistoriesFuture,
          builder: (context, snapshot) {
            // Tampilkan indikator loading saat menunggu
            if (snapshot.connectionState == ConnectionState.waiting) {
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

            // Jika data berhasil di-load
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
                // Navigasi page
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _previousPage,
                        child: const Text('Previous'),
                      ),
                      Text('Page $_currentPage'),
                      ElevatedButton(
                        onPressed: _nextPage,
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
