import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScoreCardA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2E7D32),  // Warna hijau (skor A)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SVG Icon untuk A (pastikan file SVG ada di assets)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
            ),
            child: SvgPicture.asset(
              'assets/img/score_a.svg',  // Path ke file SVG
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 16),
          
          // Deskripsi teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 8),
                Text(
                  '• Produk yang mendapat skor A adalah pilihan terbaik dari segi nutrisi.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '• Biasanya mengandung sedikit kalori, rendah lemak jenuh, sedikit gula, dan sedikit garam.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
