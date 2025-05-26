import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/page/product/detail_page.dart';
import 'package:bewise/presentation/page/product/recommendation_page.dart';
import 'package:bewise/presentation/widgets/product_image.dart';

class ProductBasePage extends StatefulWidget {
  final Product product;
  final int? historyId; // New parameter for history ID
  final String sourceType; // 'scan' or 'history'

  const ProductBasePage({
    required this.product, 
    this.historyId,
    this.sourceType = 'scan', // Default to scan
    Key? key
  }) : super(key: key);

  @override
  State<ProductBasePage> createState() => _ProductBasePageState();
}

class _ProductBasePageState extends State<ProductBasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              ProductImage(imageUrl: product.photo, label: product.label),
            ],
          ),

          // TabBar
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

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Detail Tab
                DetailPage(product: product),
                // Recommendation Tab - Pass the source information
                RecommendationPage(
                  product: widget.sourceType == 'scan' ? product : null,
                  historyId: widget.historyId,
                  sourceType: widget.sourceType,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}