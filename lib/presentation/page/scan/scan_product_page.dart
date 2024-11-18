import 'package:flutter/material.dart';

class ScanProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Product Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to Scan Product Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
