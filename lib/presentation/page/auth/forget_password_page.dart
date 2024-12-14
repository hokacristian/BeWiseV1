import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/core/widgets/input_field_widget.dart';
import 'package:bewise/presentation/widgets/custom_button_widget.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Kata Sandi'),
        backgroundColor: AppColors.lightBlue,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Masukkan email Anda untuk menerima tautan reset password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email Input
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  InputFieldWidget(
                    controller: _emailController,
                    fillColor: Colors.grey[200],
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  // Button to Submit Email
                  CustomButtonWidget(
                    text: 'Kirimi Saya Email',
                    isLoading: authProvider.isLoading,
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email tidak boleh kosong.'),
                          ),
                        );
                        return;
                      }

                      await authProvider.forgotPassword(email);

                      if (authProvider.errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email reset password berhasil dikirim.'),
                          ),
                        );
                        // Optional: Navigate back after success
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authProvider.errorMessage!),
                          ),
                        );
                      }
                    },
                    backgroundColor: AppColors.lightBlue,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
