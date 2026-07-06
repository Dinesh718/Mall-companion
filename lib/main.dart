import 'package:flutter/material.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VisitorMallApp());
}

class VisitorMallApp extends StatelessWidget {
  const VisitorMallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mall Companion',
      home: const SplashPage(),
    );
  }
}
