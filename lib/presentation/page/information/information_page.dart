import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Info Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
