import 'package:flutter/material.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(const MyApp());
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF8F5F2), // Cream White
  primaryColor: const Color(0xFFB6CDBD), // Sage Green
  cardColor: const Color(0xFFDDE0E4), 
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF4A635D)), 
    bodyMedium: TextStyle(color: Color(0xFF4A635D)),
    headlineSmall: TextStyle(
      color: Color(0xFF8A9A5B), 
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF4A635D)), 
  );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPATQ RAUDLATUL FALAH',
      theme: appTheme,
      home: LandingPage(),
    );
  }
}
