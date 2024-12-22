import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/widgets/product_price.dart';
import 'package:bewise/presentation/widgets/product_nutrition.dart';

class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({required this.product, Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    // Contoh menampilkan data basic product
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          NutritionFacts(nutritionFact: product.nutritionFact),
          PriceInfo(priceA: product.priceA, priceB: product.priceB),
        ],
      ),
    );
  }
}

