import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';
import 'package:bewise/presentation/widgets/product_price.dart';
import 'package:bewise/presentation/widgets/product_nutrition.dart';

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NutritionFacts(nutritionFact: product.nutritionFact),
          PriceInfo(priceA: product.priceA, priceB: product.priceB),
        ],
      ),
    );
  }
}
