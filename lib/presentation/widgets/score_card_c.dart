import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Kartu Skor C
class ScoreCardC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFEE272),  // Warna kuning untuk skor C
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
              'assets/img/score_c.svg',
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
                  '• Produk ini memiliki kandungan yang seimbang antara nutrisi baik dan kurang sehat, seperti kalori atau lemak lebih tinggi, namun tetap kaya serat atau protein yang bermanfaat.',
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


