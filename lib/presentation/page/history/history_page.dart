import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Riwayat Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
