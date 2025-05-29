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
              {'id': 6, 'name': 'Susu', 'icon': 'assets/img/icon_susu.svg'},
              {'id': 2, 'name': 'Teh', 'icon': 'assets/img/icon_tea.svg'},
              {'id': 1, 'name': 'Kopi', 'icon': 'assets/img/icon_coffe.svg'},
              {'id': 4, 'name': 'Soda', 'icon': 'assets/img/icon_soda.svg'},
              {'id': 5, 'name': 'Mineral', 'icon': 'assets/img/icon_water.svg'},
              {'id': 4, 'name': 'Jus', 'icon': 'assets/img/iconn_jus.svg'},
              {'id': 3, 'name': 'Energi', 'icon': 'assets/img/icon_energy.svg'},
              {'id': 3, 'name': 'Isotonik', 'icon': 'assets/img/isotonik.svg'},
            ],
          ),
          const SizedBox(height: 24),
          _buildCategorySection(
            context,
            title: 'Makanan',
            categories: [
              {'id': 11, 'name': 'Snack', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 7, 'name': 'Roti', 'icon': 'assets/img/icon_roti.svg'},
              {'id': 8, 'name': 'Mie', 'icon': 'assets/img/icon_roti.svg'},
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Ubah alignment ke center
        mainAxisSize: MainAxisSize.min,
        children: [
          // Center widget untuk memastikan judul berada di tengah
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins', // Gunakan font Poppins
                fontSize: 18, // Ukuran font yang sesuai
                fontWeight: FontWeight.bold, // Gaya font bold
                color: Colors.black, // Warna teks
              ),
              textAlign: TextAlign.center, // Teks rata tengah
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
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
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
                        style: TextStyle(
                          fontFamily:
                              'Poppins', // Gunakan font Poppins untuk text kategori
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
