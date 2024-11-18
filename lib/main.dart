import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/services/api_service.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'presentation/page/onboarding/splash_screen.dart';


void main() async {
  await dotenv.load(fileName: 'assets/env/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(ApiService()), 
        ),
      ],
      child: MaterialApp(
        title: 'BeWise',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: SplashScreen(), 
      ),
    );
  }
}
