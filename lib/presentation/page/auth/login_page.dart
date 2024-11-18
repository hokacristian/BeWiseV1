import 'package:flutter/material.dart';
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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.loginTittle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    AppStrings.loginText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 20),
                  // Email Input
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  InputFieldWidget(
                    controller: _emailController,
                    fillColor: Colors.grey[200],
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  // Password Input
                  Text(
                    'Kata Sandi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  InputFieldWidget(
                    controller: _passwordController,
                    fillColor: Colors.grey[200],
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
      MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
    );
                      },
                      child: Text(
                        'Lupa Password',
                        style: TextStyle(
                          color: AppColors.lightBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Login Button
                  CustomButtonWidget(
                    text: 'Masuk',
                    textColor: AppColors.textSecondary,
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
                          authProvider.user!.name,
                          authProvider.user!.email,
                          gender: authProvider.user!.gender,
                          avatarLink: authProvider.user!.avatarLink,
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
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
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'atau',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomButtonWidget(
                    backgroundColor: AppColors.secondary,
                    text: 'Masuk dengan Google',
                    isLoading: false,
                    onPressed: () {
                      // TODO: Implement Google login
                    },
                    icon: Icon(Icons.g_mobiledata),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Belum punya akun?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
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
          );
        },
      ),
    );
  }
}
