import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bewise/presentation/page/product/category_product_page.dart';

class CategoryAllProductPage extends StatelessWidget {
  const CategoryAllProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih untuk seluruh halaman
      appBar: AppBar(
        title: const Text('Kategori Produk'),
        backgroundColor: Colors.white, // AppBar juga putih
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategorySection(
            context,
            title: 'Minuman',
            categories: [
              {'id': 10, 'name': 'Susu', 'icon': 'assets/img/icon_susu.svg'},
              {'id': 14, 'name': 'Teh', 'icon': 'assets/img/icon_tea.svg'},
              {'id': 8, 'name': 'Kopi', 'icon': 'assets/img/icon_coffe.svg'},
              {'id': 7, 'name': 'Soda', 'icon': 'assets/img/icon_soda.svg'},
              {
                'id': 13,
                'name': 'Mineral',
                'icon': 'assets/img/icon_water.svg'
              },
              {'id': 11, 'name': 'Jus', 'icon': 'assets/img/iconn_jus.svg'},
              {
                'id': 9,
                'name': 'Yoghurt',
                'icon': 'assets/img/yogurt.svg'
              },
              {'id': 12, 'name': 'Isotonik', 'icon': 'assets/img/isotonik.svg'},
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            context,
            title: 'Makanan',
            categories: [
              {'id': 1, 'name': 'Roti', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 5, 'name': 'Mie', 'icon': 'assets/img/mie.svg'},
              {'id': 3, 'name': 'Frozen Food', 'icon': 'assets/img/frozen.svg'},
              {'id': 2, 'name': 'Biskuit', 'icon': 'assets/img/waffers.svg'},
              {'id': 4, 'name': 'Snack', 'icon': 'assets/img/snack.svg'},
              {'id': 6, 'name': 'Sereal', 'icon': 'assets/img/cereal.svg'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> categories,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Shadow abu-abu transparan
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Center widget untuk memastikan judul berada di tengah
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProductPage(
                        categoryId: category['id'] as int,
                        categoryName: category['name'] as String,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey
                            .shade50, // Background icon sedikit abu-abu muda
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 0.5,
                        ),
                      ),
                      child: SvgPicture.asset(
                        category['icon'] as String,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
