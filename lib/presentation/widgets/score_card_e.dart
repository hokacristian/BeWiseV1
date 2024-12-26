import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Kartu Skor E
class ScoreCardE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF1947A),  // Warna merah untuk skor E
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/img/score_e.svg',
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '• Produk ini memiliki tingkat kalori yang sangat tinggi, banyak lemak jenuh, gula, dan garam.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '• Pilihan ini sebaiknya dihindari atau hanya dikonsumsi dalam jumlah sangat kecil.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

