import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bewise/presentation/page/product/category_product_page.dart';

class CategoryAllProductPage extends StatelessWidget {
  const CategoryAllProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Produk'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategorySection(
            context,
            title: 'Minuman',
            categories: [
              {'id': 1, 'name': 'Susu', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 2, 'name': 'Teh', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 3, 'name': 'Kopi', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 4, 'name': 'Soda', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 5, 'name': 'Mineral', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 6, 'name': 'Jus', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 7, 'name': 'Energi', 'icon': 'assets/img/icon_roti.svg'},

            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            context,
            title: 'Makanan',
            categories: [
              {'id': 9, 'name': 'Snack', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 10, 'name': 'Roti', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 11, 'name': 'Mie', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 12, 'name': 'Buah', 'icon': 'assets/img/icon_roti.svg'},
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
    margin: const EdgeInsets.only(bottom: 16), // Tambahkan margin bawah
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Tambahkan ini
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12, // Kurangi spacing vertikal
            childAspectRatio: 0.8, // Sesuaikan aspect ratio
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
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min, // Tambahkan ini
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      category['icon'] as String,
                    ),
                  ),
                  const SizedBox(height: 4), // Kurangi jarak
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      category['name'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10, // Perkecil ukuran font
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