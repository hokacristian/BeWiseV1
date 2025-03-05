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

            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            context,
            title: 'Makanan',
            categories: [
              {'id': 7, 'name': 'Snack', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 8, 'name': 'Roti', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 9, 'name': 'Mie', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 10, 'name': 'Buah', 'icon': 'assets/img/icon_roti.svg'},
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
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
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
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
                    child: SvgPicture.asset(
                      category['icon'] as String,
                      height: 48,
                      width: 48,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}