import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScoreCardA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF74AB83), // Green color for A score
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF5E8B6B), // Darker green for circle
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'A',
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
                  'Produk yang mendapat skor A adalah pilihan terbaik dari segi nutrisi.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Biasanya mengandung sedikit kalori, rendah lemak jenuh, sedikit gula, dan sedikit garam.',
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
