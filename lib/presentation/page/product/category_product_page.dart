import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/presentation/page/product/product_base_page.dart';

class CategoryProductPage extends StatefulWidget {
  final int categoryId;

  const CategoryProductPage({required this.categoryId, super.key});

  @override
  State<CategoryProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  late int _currentPage = 1;
  bool _isInitialized = false;
  bool _isLoadingProduct = false;

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        productProvider.fetchProductsByCategory(
            widget.categoryId, _currentPage);
        _isInitialized = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Kategori ${widget.categoryId}'),
      ),
      body: Stack(
        children: [
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (provider.errorMessage != null) {
                return Center(
                  child: Text(
                    'Terjadi kesalahan: ${provider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (provider.products.isEmpty) {
                return const Center(
                  child: Text('Tidak ada produk ditemukan.'),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          return GestureDetector(
                            onTap: () async {
                              // Show loading indicator
                              setState(() {
                                _isLoadingProduct = true;
                              });

                              try {
                                // Fetch the complete product with nutritionFact
                                await provider.fetchProductById(product.id);

                                // Add debug logs
                                print(
                                    "CATEGORY_PAGE Debug - Product ID: ${product.id}");
                                print(
                                    "CATEGORY_PAGE Debug - After fetchProductById, nutritionFact exists: ${provider.product?.nutritionFact != null}");
                                if (provider.product?.nutritionFact != null) {
                                  print(
                                      "CATEGORY_PAGE Debug - NutritionFact data: energy=${provider.product?.nutritionFact?.energy}, protein=${provider.product?.nutritionFact?.protein}");
                                }

                                // Navigate only if product was fetched successfully
                                if (provider.product != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductBasePage(
                                          product: provider.product!),
                                    ),
                                  );
                                } else {
                                  // Show error if product could not be fetched
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Gagal memuat detail produk')),
                                  );
                                }
                              } catch (e) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${e.toString()}')),
                                );
                              } finally {
                                // Hide loading indicator
                                setState(() {
                                  _isLoadingProduct = false;
                                });
                              }
                            },
                            child: ProductCard(product: product),
                          );
                        },
                      ),
                    ),
                    if (provider.products.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (provider.hasPreviousPage)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                  productProvider.fetchProductsByCategory(
                                      widget.categoryId, _currentPage);
                                },
                                child: const Text('Previous'),
                              ),
                            const SizedBox(width: 10),
                            Text(
                                'Page ${provider.currentPage} of ${provider.totalPages}'),
                            const SizedBox(width: 10),
                            if (provider.hasNextPage)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                  productProvider.fetchProductsByCategory(
                                      widget.categoryId, _currentPage);
                                },
                                child: const Text('Next'),
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              }
            },
          ),

          // Show a full-screen loading indicator when fetching product details
          if (_isLoadingProduct)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
