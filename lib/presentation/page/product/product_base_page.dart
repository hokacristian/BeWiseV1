import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/page/product/detail_page.dart';
import 'package:bewise/presentation/page/product/recommendation_page.dart';
import 'package:bewise/presentation/widgets/product_image.dart';

class ProductBasePage extends StatefulWidget {
  final Product product; // <--- terima Product langsung

  const ProductBasePage({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductBasePage> createState() => _ProductBasePageState();
}

class _ProductBasePageState extends State<ProductBasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Kita tidak perlu lagi _fetchProductFuture, karena data sudah ada di widget.product
  // Product? _product; -> Tidak mutlak perlu, bisa langsung pakai widget.product

  @override
  void initState() {
    super.initState();
    // Inisialisasi Tab Controller
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product; // ambil data product

    return Scaffold(
      appBar: AppBar(
        title: Text('Produk: ${product.name}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Stack(
            children: [
              ProductImage(imageUrl: product.photo, label: product.label),
            ],
          ),

          // TabBar di bawah gambar
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
                // Kirim product ke DetailPage
                DetailPage(product: product),
                // Kirim product ke RecommendationPage
                RecommendationPage(product: product),
              ],
            ),
          )
        ],
      ),
    );
  }
}
