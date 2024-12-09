import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final Color? fillColor;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const InputFieldWidget({
    required this.controller,
    this.labelText,
    this.fillColor,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12.0), // Atur besar rounded di sini
          borderSide: BorderSide.none, // Hilangkan garis outline
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
