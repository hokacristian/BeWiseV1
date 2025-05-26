import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Kartu Skor B
class ScoreCardB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBFD789), // Light green color for B score
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF9BC063), // Darker light green for circle
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'B',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Description text
          Expanded(
            child: Text(
              'Produk dengan skor B masih termasuk sehat, tetapi mungkin mengandung sedikit lebih banyak kalori, gula, atau lemak dibanding produk dengan skor A.',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

