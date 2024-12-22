import 'package:flutter/material.dart';
import 'package:bewise/data/models/product_model.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final Label? label;

  const ProductImage({required this.imageUrl, this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Image.network(
          imageUrl,
          height: 300,
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 250, color: Colors.grey);
          },
        ),
        if (label != null)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                label!.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
