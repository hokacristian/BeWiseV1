import 'package:flutter/material.dart';

class TrialButton extends StatelessWidget {
  final VoidCallback onPressed;
  const TrialButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF191F68),
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(minWidth: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mulai uji coba gratis 3 hari',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Setelah itu Rp19.999 / Bulan',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.lightGreenAccent.shade100,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
