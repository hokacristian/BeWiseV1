import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:bewise/presentation/page/product/product_base_page.dart';
import 'package:bewise/presentation/widgets/product_card.dart';
import 'package:bewise/data/providers/product_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  bool _isLoadingProduct = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    // Directly load all products when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      setState(() => _isSearching = true);
      Provider.of<ProductProvider>(context, listen: false)
          .searchProducts(query, 1, 10);
    } else {
      setState(() => _isSearching = false);
      Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Skeletonizer(
                  enabled: productProvider.isLoading, // Skeleton aktif saat loading
                  child: _buildGrid(productProvider),
                ),
              );
            },
          ),
          // Overlay loading indicator when fetching product details
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

  Widget _buildGrid(ProductProvider productProvider) {
    if (productProvider.errorMessage != null) {
      return Center(child: Text(productProvider.errorMessage!));
    } else if (productProvider.products.isEmpty) {
      return const Center(child: Text('Produk tidak tersedia'));
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: productProvider.isLoading ? 6 : productProvider.products.length,
        itemBuilder: (context, index) {
          if (productProvider.isLoading) {
            return _buildSkeletonCard();
          }
          final product = productProvider.products[index];
          return GestureDetector(
            onTap: () async {
              // Show loading indicator
              setState(() {
                _isLoadingProduct = true;
              });
              
              try {
                // First fetch the complete product data with nutritionFact
                await productProvider.fetchProductById(product.id);
                
                // Navigate only if product was fetched successfully
                if (productProvider.product != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductBasePage(product: productProvider.product!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal memuat detail produk')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
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
      );
    }
  }

  // Skeleton Card untuk efek loading
  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: double.infinity,
    );
  }
}