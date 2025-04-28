import 'package:bewise/core/constans/string.dart';
import 'package:flutter/material.dart';
import 'package:bewise/presentation/widgets/score_card_a.dart';
import 'package:bewise/presentation/widgets/score_card_b.dart';
import 'package:bewise/presentation/widgets/score_card_c.dart';
import 'package:bewise/presentation/widgets/score_card_d.dart';
import 'package:bewise/presentation/widgets/score_card_e.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  static const String infoPage1 = 'Nutri-Score adalah label gizi yang memudahkan konsumen memilih makanan lebih sehat. Dikembangkan di Prancis, sistem ini menilai nutrisi produk berdasarkan komposisi gizinya.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text('Info Page'),
  ),
  body: ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Image.asset('assets/img/banner.png'),
      Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              infoPage1,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16), // Memberikan jarak antara infoPage1 dan infoPage2
            Text(
              AppStrings.infoPage2,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
           ScoreCardA(),  
           ScoreCardB(),  
           ScoreCardC(),  
           ScoreCardD(),  
           ScoreCardE(),  
        ],
      ),
    );
  }
}