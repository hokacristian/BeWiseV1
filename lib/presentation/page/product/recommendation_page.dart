import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/presentation/page/product/detail_product_page.dart';


class RecommendationPage extends StatelessWidget {
  final Product product;
  const RecommendationPage({Key? key, required this.product}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    // Ambil list rekomendasi langsung dari product
    final rekomendasi = product.rekomendasi ?? [];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool isPremium = authProvider.subscription?.isActive ?? false;

 if (!isPremium) {
      return Scaffold(
        body: Center(
          child: Text(
            'Mohon maaf fitur ini tidak tersedia, silahkan melakukan aktivasi Premium Terlebih Dahulu',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

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

        // Wrap dengan GestureDetector untuk navigasi ke halaman detail
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  productId: productRekomen.id,  // Kirim productId ke detail
                ),
              ),
            );
          },
          child: ProductCard(product: productRekomen),
        );
      },
    );
  }
}
