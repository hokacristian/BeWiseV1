import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final double? iconHeight; // Tinggi ikon
  final double? iconWidth; // Lebar ikonF // Add this parameter for the icon

  const CustomButtonWidget({super.key, 
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.icon,
    this.iconHeight, // Tambahkan height
    this.iconWidth, // Tambahkan width
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: isLoading
          ? CircularProgressIndicator(
              color: textColor,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  SizedBox(
                    height: iconHeight ?? 24.0, // Default height 24
                    width: iconWidth ?? 24.0, // Default width 24
                    child: icon, // Gunakan ikon yang diberikan
                  ), // Display the icon if provided
                if (icon != null)
                  const SizedBox(width: 12), // Add spacing between icon and text
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
    );
  }
}
