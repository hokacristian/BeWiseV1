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
        _buildNutritionBox(
          iconAsset: 'assets/img/calories.svg',
          value: '${nutritionFact!.energy}',
          unit: 'kkal',
          label: 'Energi',
        ),
        _buildNutritionBox(
          iconAsset: 'assets/img/lipid.svg',
          value: '${nutritionFact!.saturatedFat}',
          unit: 'gr',
          label: 'Lemak',
        ),
        _buildNutritionBox(
          iconAsset: 'assets/img/muscle.svg',
          value: '${nutritionFact!.protein}',
          unit: 'gr',
          label: 'Protein',
        ),
        _buildNutritionBox(
          iconAsset: 'assets/img/sugar-cube.svg',
          value: '${nutritionFact!.sugar}',
          unit: 'gr',
          label: 'Gula',
        ),
        _buildNutritionBox(
          iconAsset: 'assets/img/sodium.svg',
          value: '${nutritionFact!.sodium}',
          unit: 'mg',
          label: 'Sodium',
        ),
      ],
    );
  }

  Widget _buildNutritionBox({
    required String iconAsset,
    required String value,
    required String unit,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Box putih hanya berisi icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              width: 24,
              height: 24,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Value + Unit di luar box
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            children: [
              TextSpan(text: value),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 2),
        
        // Label di luar box
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}