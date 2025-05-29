import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/widgets/product_nutrition.dart';
import 'package:bewise/presentation/widgets/score_card_a.dart';
import 'package:bewise/presentation/widgets/score_card_b.dart';
import 'package:bewise/presentation/widgets/score_card_c.dart';
import 'package:bewise/presentation/widgets/score_card_d.dart';
import 'package:bewise/presentation/widgets/score_card_e.dart';

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({required this.product, Key? key}) : super(key: key);

  // Widget untuk memanggil ScoreCard berdasarkan label
  Widget getScoreCard(String label) {
    switch (label.toUpperCase()) {
      case 'A':
        return ScoreCardA();
      case 'B':
        return ScoreCardB();
      case 'C':
        return ScoreCardC();
      case 'D':
        return ScoreCardD();
      case 'E':
        return ScoreCardE();
      default:
        return Container(
          padding: const EdgeInsets.all(16),
          child: const Text('Label tidak valid'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content with SingleChildScrollView
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90), // Bottom padding untuk price bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF093), // Light green background
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand
                        Text(
                          product.brand,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Product Name
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Score Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: getScoreCard(product.label?.name ?? 'C'),
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        // Nutrition Facts - Langsung tanpa container background
                        if (product.nutritionFact != null)
                          NutritionFacts(nutritionFact: product.nutritionFact),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Price information fixed at the bottom - nempel di paling bawah
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SafeArea(
                  top: false, // Tidak perlu safe area di atas
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Informasi Harga',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF093),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Rp ${_formatPrice(product.priceA)} - Rp ${_formatPrice(product.priceB)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}