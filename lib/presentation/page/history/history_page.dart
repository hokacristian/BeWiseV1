import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to Riwayat Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
