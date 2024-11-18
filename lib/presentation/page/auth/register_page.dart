import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/core/widgets/input_field_widget.dart';
import 'package:bewise/presentation/widgets/custom_button_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Daftar Sekarang!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Buat akun dalam sekejap dan rasakan pengalaman terbaik bersama kami.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textFourth,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 20),

                  // Input Nama
                  _buildInputField(
                    label: 'Nama',
                    controller: _nameController,
                  ),
                  SizedBox(height: 10),

                  // Input Email
                  _buildInputField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),

                  // Input Kata Sandi
                  _buildInputField(
                    label: 'Kata Sandi',
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Pesan Error
                  if (authProvider.errorMessage != null)
                    Text(
                      authProvider.errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 16),

                  // Tombol Daftar
                  CustomButtonWidget(
                    text: 'Daftar',
                    isLoading: authProvider.isLoading,
                    onPressed: () async {
                      await authProvider.register(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (authProvider.errorMessage == null) {
                        // Navigasi ke halaman login jika registrasi berhasil
                        Navigator.pop(context);
                      } else {
                        // Tampilkan snackbar jika terjadi error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authProvider.errorMessage!),
                          ),
                        );
                      }
                    },
                    backgroundColor: AppColors.lightBlue,
                    textColor: AppColors.textPrimary,
                  ),
                  SizedBox(height: 10),

                  // Separator
                  Center(
                    child: Text(
                      'atau',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.textFourth,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Tombol Daftar dengan Google
                  CustomButtonWidget(
                    backgroundColor: AppColors.secondary,
                    text: 'Daftar dengan Google',
                    isLoading: false,
                    onPressed: () {
                      // Implementasi login dengan Google
                    },
                    icon: Icon(
                      Icons.g_mobiledata,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Tautan ke halaman login
                  Center(
                    child: Text(
                      'Sudah punya akun?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.textFourth,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Masuk Di sini',
                      style: TextStyle(
                        color: AppColors.lightBlue,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 8),
        InputFieldWidget(
          controller: controller,
          fillColor: Colors.grey[200],
          obscureText: obscureText,
          keyboardType: keyboardType,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }
}
