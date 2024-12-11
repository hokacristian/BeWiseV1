import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/widgets/product_image.dart';
import 'package:bewise/presentation/widgets/product_price.dart';
import 'package:bewise/presentation/widgets/product_nutrition.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({required this.productId, Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<void> _fetchProductFuture;

  @override
  void initState() {
    super.initState();
    _fetchProductFuture = _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: FutureBuilder<void>(
        future: _fetchProductFuture,
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
            final product = productProvider.product;
            if (product == null) {
              return const Center(
                child: Text('Produk tidak ditemukan.'),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImage(imageUrl: product.photo, label: product.label),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  NutritionFacts(nutritionFact: product.nutritionFact),
                  PriceInfo(price: product.price),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
