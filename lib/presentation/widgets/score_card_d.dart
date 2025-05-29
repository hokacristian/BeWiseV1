import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Kartu Skor D
class ScoreCardD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6B971), // Orange color for D score
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFE8974F), // Darker orange for circle
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'D',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Produk dengan skor D lebih tinggi kandungan kalorinya dan lebih banyak mengandung gula, lemak jenuh, atau garam.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Disarankan untuk dikonsumsi dalam jumlah terbatas.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
