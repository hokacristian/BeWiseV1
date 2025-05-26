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
          iconAsset: 'assets/img/calories.svg',
        ),
        _buildNutritionCircle(
          iconAsset: 'assets/img/lipid.svg',
        ),
        _buildNutritionCircle(
          iconAsset: 'assets/img/muscle.svg',
        ),
        _buildNutritionCircle(
          iconAsset: 'assets/img/sugar-cube.svg',
        ),
        _buildNutritionCircle(
          iconAsset: 'assets/img/sodium.svg',
        ),
      ],
    );
  }

  Widget _buildNutritionCircle({
    required String iconAsset,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          iconAsset,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}