import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/widgets/product_card.dart';

class RecommendationPage extends StatelessWidget {
  final Product product;
  const RecommendationPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil list rekomendasi langsung dari product
    final rekomendasi = product.rekomendasi ?? [];

    print('Rekomendasi Produk di Page: ${rekomendasi.length}');

    if (rekomendasi.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada rekomendasi produk',
          style: TextStyle(fontSize: 20, color: Colors.grey[600]),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: rekomendasi.length,
      itemBuilder: (context, index) {
        final productRekomen = rekomendasi[index];
        print('Menampilkan Produk: ${productRekomen.name}');
        return ProductCard(product: productRekomen);
      },
    );
  }
}
