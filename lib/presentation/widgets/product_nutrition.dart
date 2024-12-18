import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';

class NutritionFacts extends StatelessWidget {
  final NutritionFact? nutritionFact;

  const NutritionFacts({this.nutritionFact, super.key});

  @override
  Widget build(BuildContext context) {
    if (nutritionFact == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fakta Nutrisi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutritionItem('Energi', '${nutritionFact!.energy} kkal'),
              _buildNutritionItem('Lemak', '${nutritionFact!.saturatedFat} gr'),
              _buildNutritionItem('Protein', '${nutritionFact!.protein} gr'),
              _buildNutritionItem('Gula', '${nutritionFact!.sugar} gr'),
              _buildNutritionItem('Natrium', '${nutritionFact!.sodium} mg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
