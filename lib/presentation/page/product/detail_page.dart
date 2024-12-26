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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFDDF093), 
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blueAccent,
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
              const SizedBox(height: 16),

              // Informasi Harga
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Informasi Harga ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rp ${product.priceA} - Rp ${product.priceB}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
