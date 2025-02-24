import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/presentation/page/product/product_base_page.dart';

class CategoryProductPage extends StatelessWidget {
  final int categoryId;

  const CategoryProductPage({required this.categoryId, super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Kategori $categoryId'),
      ),
      body: FutureBuilder(
        future: productProvider.fetchProductsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.products.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada produk ditemukan.'),
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
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
