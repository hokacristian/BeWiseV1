import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/page/product/product_base_page.dart';

class RecommendationPage extends StatefulWidget {
  final Product? product;
  final int? historyId; // New parameter for history ID
  final String? sourceType; // 'scan' or 'history'
  
  const RecommendationPage({
    Key? key, 
    this.product,
    this.historyId,
    this.sourceType = 'scan', // Default to scan
  }) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  @override
  void initState() {
    super.initState();
    // Fetch history recommendations if coming from history
    if (widget.sourceType == 'history' && widget.historyId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProductProvider>(context, listen: false)
            .fetchHistoryRecommendation(widget.historyId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        List<Product> recommendations = [];
        bool isLoading = false;
        String? errorMessage;

        // Determine which recommendations to show based on source type
        if (widget.sourceType == 'history') {
          recommendations = productProvider.historyRecommendations;
          isLoading = productProvider.isLoadingHistoryRecommendations;
          errorMessage = productProvider.errorMessageHistoryRecommendations;
        } else {
          // Default to scan recommendations from product
          recommendations = widget.product?.rekomendasi ?? [];
        }

        print('Rekomendasi Produk di Page (${widget.sourceType}): ${recommendations.length}');

        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Gagal memuat rekomendasi',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (widget.sourceType == 'history' && widget.historyId != null) {
                      productProvider.fetchHistoryRecommendation(widget.historyId!);
                    }
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (recommendations.isEmpty) {
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
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            final productRekomen = recommendations[index];
            print('Menampilkan Produk: ${productRekomen.name}');

            return GestureDetector(
              onTap: () async {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // Fetch complete product data first
                  await productProvider.fetchProductById(productRekomen.id);
                  
                  // Close loading dialog
                  Navigator.of(context).pop();
                  
                  // Navigate to ProductBasePage with complete data
                  if (productProvider.product != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductBasePage(
                          product: productProvider.product!,
                          sourceType: 'scan', // From recommendation, treat as scan
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal memuat detail produk')),
                    );
                  }
                } catch (e) {
                  // Close loading dialog
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: ProductCard(product: productRekomen),
            );
          },
        );
      },
    );
  }
}