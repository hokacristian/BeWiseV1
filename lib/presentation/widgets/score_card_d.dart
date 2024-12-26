import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Kartu Skor D
class ScoreCardD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF6B971),  // Warna oranye untuk skor D
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
              'assets/img/score_d.svg',
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
                  '• Produk dengan skor D lebih tinggi kandungan kalorinya dan lebih banyak mengandung gula, lemak jenuh, atau garam.',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '• Disarankan untuk dikonsumsi dalam jumlah terbatas.',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

