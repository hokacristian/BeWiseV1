import 'package:flutter/material.dart';
import 'package:bewise/presentation/widgets/score_card_a.dart';


class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Info Page'),
      ),
      body: ListView(
        padding:  EdgeInsets.all(16),
        children:  [
          ScoreCardA(),  // Panggil widget A
        ],
      ),
    );
  }
}
