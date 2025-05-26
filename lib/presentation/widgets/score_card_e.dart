import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Kartu Skor E
class ScoreCardE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1947A), // Red/coral color for E score
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFE67E52), // Darker red/coral for circle
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'E',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Produk ini memiliki tingkat kalori yang sangat tinggi, banyak lemak jenuh, gula, dan garam.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pilihan ini sebaiknya dihindari atau hanya dikonsumsi dalam jumlah sangat kecil.',
                  style: TextStyle(
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

