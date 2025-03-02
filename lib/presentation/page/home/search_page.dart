import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
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
          onChanged: (query) {
            if (query.isNotEmpty) {
              Provider.of<ProductProvider>(context, listen: false)
                  .searchProducts(query, 1, 10);
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (productProvider.errorMessage != null) {
            return Center(child: Text(productProvider.errorMessage!));
          } else if (_searchController.text.isEmpty) {
            return const Center(
              child: Text('Ketik nama produk yang ingin dicari'),
            );
          } else if (productProvider.products.isEmpty) {
            return const Center(child: Text('Produk tidak ditemukan'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
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
              ),
            );
          }
        },
      ),
    );
  }
}