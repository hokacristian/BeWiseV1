import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:bewise/data/services/api_service.dart';
import 'package:bewise/data/providers/auth_provider.dart';
import 'package:bewise/data/providers/product_provider.dart';
import 'presentation/page/onboarding/splash_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  // Load environment variables
  await dotenv.load(fileName: 'assets/env/.env');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ApiService
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(apiService: apiService),
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
