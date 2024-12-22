import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'package:bewise/presentation/page/product/detail_page.dart';
import 'package:bewise/presentation/widgets/product_image.dart';
import 'package:bewise/presentation/page/product/recommendation_page.dart';
import 'package:bewise/data/models/product_model.dart';

class ProductBasePage extends StatefulWidget {
  final int productId;

  const ProductBasePage({required this.productId, super.key});

  @override
  State<ProductBasePage> createState() => _ProductBasePageState();
}

class _ProductBasePageState extends State<ProductBasePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<void> _fetchProductFuture;
  Product? _product;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProductFuture = _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.fetchProductById(widget.productId);
    setState(() {
      _product = productProvider.product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Kategori '),
      ),
      body: FutureBuilder<void>(
        future: _fetchProductFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          } else if (_product == null) {
            return const Center(
              child: Text('Produk tidak ditemukan.'),
            );
          }

          

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stack untuk mengatur gambar dan tombol back
              Stack(
                children: [
                  // Gambar Produk
                  ProductImage(imageUrl: _product!.photo, label: _product!.label),
                  
                ],
              ),

              // TabBar di bawah gambar (dalam Container seperti tombol besar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: 'Detail'),
                        Tab(text: 'Rekomendasi Produk'),
                      ],
                    ),
                  ),
                ),
              ),

              // Isi Halaman Tab
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    DetailPage(product: _product!),
                    const RecommendationPage(), // Halaman rekomendasi produk
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
