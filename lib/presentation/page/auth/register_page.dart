import 'package:bewise/presentation/page/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/core/widgets/input_field_widget.dart';
import 'package:bewise/presentation/widgets/custom_button_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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
      backgroundColor: AppColors.brokenWhite,
      resizeToAvoidBottomInset: false, // Mencegah konten bergeser saat keyboard muncul
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tombol Kembali
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Daftar Sekarang!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Buat akun dalam sekejap dan rasakan pengalaman terbaik bersama kami.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input Nama
                    _buildInputField(
                      label: 'Nama',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 10),

                    // Input Email
                    _buildInputField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),

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
                    const SizedBox(height: 20),

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
                          // Navigasi ke halaman login jika berhasil
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        } else {
                          // Tampilkan error jika ada
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
                    const SizedBox(height: 10),

                    // Separator
                    const Center(
                      child: Text(
                        'atau',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tombol Daftar dengan Google
                    CustomButtonWidget(
                      backgroundColor: AppColors.secondary,
                      text: 'Daftar dengan Google',
                      isLoading: false,
                      onPressed: () {
                        // Implementasi login dengan Google
                      },
                      icon: SvgPicture.asset(
                        'assets/img/google.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Footer tetap di bagian bawah layar
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
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
              ),
            ],
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
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
