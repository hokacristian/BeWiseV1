import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/widgets/product_price.dart';
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
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFDDF093),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFFDDF093),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Text(
                        product.brand,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Nama Produk
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Kartu Skor berdasarkan label
                      getScoreCard(product.label?.name ?? 'Unknown'),

                      const SizedBox(height: 16),

                      // Fakta Nutrisi
                      NutritionFacts(nutritionFact: product.nutritionFact),

                      // Adding extra padding at the bottom to ensure content isn't covered by the price bar
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),

            // Price information fixed at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.black,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Informasi Harga',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFDDF093),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Rp ${product.priceA} - Rp ${product.priceB}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
