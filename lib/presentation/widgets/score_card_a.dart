import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScoreCardA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF74AB83),  // Warna hijau (skor A)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,  // Pastikan crossAxisAlignment adalah center
        children: [
          // SVG Icon untuk A
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/img/score_a.svg',
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 16),

          // Deskripsi teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,  // Teks sejajar vertikal di tengah
              children: const [
                Text(
                  '• Produk yang mendapat skor A adalah pilihan terbaik dari segi nutrisi.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Biasanya mengandung sedikit kalori, rendah lemak jenuh, sedikit gula, dan sedikit garam.',
                  style: TextStyle(
                    color: Colors.black,
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

