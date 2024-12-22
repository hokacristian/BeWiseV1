import 'package:flutter/material.dart';

class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Rekomendasi Produk',
        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
      ),
    );
  }
}
