import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bewise/data/models/product_model.dart';

class NutritionFacts extends StatelessWidget {
  final NutritionFact? nutritionFact;

  const NutritionFacts({this.nutritionFact, super.key});

  @override
  Widget build(BuildContext context) {
    if (nutritionFact == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNutritionCircle(
          value: '${nutritionFact!.energy}',
          unit: 'kkal',
          label: 'Energi',
          iconAsset: 'assets/img/google.svg',
        ),
        _buildNutritionCircle(
          value: '${nutritionFact!.saturatedFat}',
          unit: 'gr',
          label: 'Lemak',
          iconAsset: 'assets/img/google.svg',
        ),
        _buildNutritionCircle(
          value: '${nutritionFact!.protein}',
          unit: 'gr',
          label: 'Protein',
          iconAsset: 'assets/img/google.svg',
        ),
        _buildNutritionCircle(
          value: '${nutritionFact!.sugar}',
          unit: 'gr',
          label: 'Gula',
          iconAsset: 'assets/img/google.svg',
        ),
        _buildNutritionCircle(
          value: '${nutritionFact!.sodium}',
          unit: 'mg',
          label: 'Sodium',
          iconAsset: 'assets/img/google.svg',
        ),
      ],
    );
  }

  Widget _buildNutritionCircle({
    required String value,
    required String unit,
    required String label,
    required String iconAsset,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
                    padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: SvgPicture.asset(
            iconAsset,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: '$value '),
              TextSpan(
                text: unit,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
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
