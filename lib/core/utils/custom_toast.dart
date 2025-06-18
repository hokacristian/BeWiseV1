import 'dart:async';
import 'package:flutter/material.dart';

class CustomToast {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    ToastPosition position = ToastPosition.center, 
  }) {
    // Remove existing toast
    _removeToast();

    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildToastWidget(
        message,
        backgroundColor,
        textColor,
        position,
        screenSize,
      ),
    );

    // Insert overlay
    Overlay.of(context).insert(_overlayEntry!);

    // Set timer to remove toast
    _timer = Timer(duration, () {
      _removeToast();
    });
  }

  static Widget _buildToastWidget(
    String message,
    Color backgroundColor,
    Color textColor,
    ToastPosition position,
    Size screenSize,
  ) {
    Widget toastContent = Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.8, // Maksimal 80% lebar layar
          minWidth: 120,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    // Position based on enum
    switch (position) {
      case ToastPosition.top:
        return Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: Center(child: toastContent),
        );
        
      case ToastPosition.center:
        return Positioned.fill(
          child: Center(
            child: toastContent,
          ),
        );
        
      case ToastPosition.bottom:
        return Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Center(child: toastContent),
        );
    }
  }

  static void _removeToast() {
    _timer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _timer = null;
  }

  // Shortcut methods dengan posisi center sebagai default
  static void showError(BuildContext context, String message, {ToastPosition position = ToastPosition.center}) {
    show(
      context,
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      position: position,
    );
  }

  static void showSuccess(BuildContext context, String message, {ToastPosition position = ToastPosition.center}) {
    show(
      context,
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      position: position,
    );
  }

  static void showInfo(BuildContext context, String message, {ToastPosition position = ToastPosition.center}) {
    show(
      context,
      message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      position: position,
    );
  }

  static void showWarning(BuildContext context, String message, {ToastPosition position = ToastPosition.center}) {
    show(
      context,
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      position: position,
    );
  }

  // Method khusus untuk toast center dengan styling yang lebih menarik
  static void showCenterError(BuildContext context, String message) {
    show(
      context,
      message,
      backgroundColor: Colors.red.shade600,
      textColor: Colors.white,
      position: ToastPosition.center,
      duration: const Duration(seconds: 3),
    );
  }

  static void showCenterSuccess(BuildContext context, String message) {
    show(
      context,
      message,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      position: ToastPosition.center,
      duration: const Duration(seconds: 2),
    );
  }
}

enum ToastPosition { top, center, bottom }

// // ========================================
// // CARA PENGGUNAAN DI SCAN_PRODUCT_PAGE:
// // ========================================

// // Ganti method _showErrorMessage dengan:
// void _showErrorMessage(String message) {
//   CustomToast.showError(context, message); // Default center
  
//   // Atau eksplisit specify position:
//   // CustomToast.showError(context, message, position: ToastPosition.center);
  
//   // Atau gunakan method khusus center:
//   // CustomToast.showCenterError(context, message);
// }

// void _showSuccessMessage(String message) {
//   CustomToast.showSuccess(context, message); // Default center
// }

// // Contoh penggunaan dengan posisi berbeda:
// void _showTopMessage(String message) {
//   CustomToast.showInfo(context, message, position: ToastPosition.top);
// }

// void _showBottomMessage(String message) {
//   CustomToast.showWarning(context, message, position: ToastPosition.bottom);
// }