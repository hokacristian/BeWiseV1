import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/presentation/page/product/detail_product_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<void> _fetchHistoriesFuture;

  @override
  void initState() {
    super.initState();
    _fetchHistoriesFuture = _fetchHistories();
  }

  Future<void> _fetchHistories() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchScanHistories(1, 10); // Ambil data riwayat
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Produk'),
      ),
      body: FutureBuilder<void>(
        future: _fetchHistoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonGrid();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            if (productProvider.products.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada riwayat yang tersedia.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(productId: product.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ProductCard(product: product),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10, // Jumlah skeleton card
      itemBuilder: (context, index) {
        return Skeletonizer(
          enabled: true, // Aktifkan skeleton mode
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            height: 120,
            width: double.infinity,
          ),
        );
      },
    );
  }
}
