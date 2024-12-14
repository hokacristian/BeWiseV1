import 'package:flutter/material.dart';

class ScanProductPage extends StatelessWidget {
  const ScanProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Scan Product Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
