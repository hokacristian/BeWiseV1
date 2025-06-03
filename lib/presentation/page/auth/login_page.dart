import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/core/utils/sessionmanager.dart';
import 'package:bewise/core/constans/string.dart';
import 'package:bewise/core/constans/colors.dart';
import 'package:bewise/core/widgets/input_field_widget.dart';
import 'package:bewise/presentation/widgets/custom_button_widget.dart';
import 'package:bewise/presentation/page/home/main_screen.dart';
import 'package:bewise/presentation/page/auth/register_page.dart';
import 'package:bewise/presentation/page/auth/forget_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SessionManager _sessionManager = SessionManager();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.brokenWhite,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Stack(
            children: [
              // Konten utama
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tambahkan tombol kembali di bagian atas
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Padding tambahan di bawah tombol kembali
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppStrings.loginTittle,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      AppStrings.loginText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
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
                      fillColor: AppColors.grey,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    // Password Input
                    const Text(
                      'Kata Sandi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    InputFieldWidget(
                      controller: _passwordController,
                      fillColor: AppColors.grey,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPasswordPage()),
                          );
                        },
                        child: const Text(
                          'Lupa Password',
                          style: TextStyle(
                            color: AppColors.lightBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    CustomButtonWidget(
                      text: 'Masuk',
                      textColor: Colors.black,
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        try {
                          await authProvider.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          // Save session
                          await _sessionManager.saveSession(
                            authProvider.token!,
                            authProvider.user!.id,
                            authProvider.user!.firstName,
                            authProvider.user!.lastName,
                            authProvider.user!.email,
                            gender: authProvider.user!.gender,
                            avatarLink: authProvider.user!.avatarLink,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(authProvider.errorMessage!),
                            ),
                          );
                        }
                      },
                      backgroundColor: AppColors.yellow,
                    ),
                    const SizedBox(height: 10),
                    // const Center(
                    //   child: Text(
                    //     'atau',
                    //     style: TextStyle(
                    //       fontFamily: 'Poppins',
                    //       fontSize: 14,
                    //       color: Color(0xFF666666),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    // CustomButtonWidget(
                    //   backgroundColor: AppColors.secondary,
                    //   text: 'Masuk dengan Google',
                    //   isLoading: false,
                    //   onPressed: () {
                       
                    //   },
                    //   icon: SvgPicture.asset('assets/img/google.svg'),
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Footer di bagian bawah layar
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
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
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          'Daftar Di sini',
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
}
