import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to Info Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
