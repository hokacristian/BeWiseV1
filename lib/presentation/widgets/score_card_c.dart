import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Kartu Skor C
class ScoreCardC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE272), // Yellow color for C score
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF4C430), // Darker yellow for circle
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'C',
                style: TextStyle(
                  fontFamily: 'Poppins',
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
              'Produk ini memiliki kandungan yang seimbang antara nutrisi baik dan kurang sehat, seperti kalori atau lemak lebih tinggi, namun tetap kaya serat atau protein yang bermanfaat.',
              style: const TextStyle(
                fontFamily: 'Poppins',
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
