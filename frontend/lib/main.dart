import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import './screens/dashboard/main.dart';
import 'screens/landing_page.dart'; 
import 'providers/auth_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(), 
      child: const MyApp(),
    ),
  );
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF8F5F2), 
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.green, 
    secondary: Colors.black54, 
  ),
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
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return Center(child: CircularProgressIndicator()); 
          } else if (authProvider.isLoggedIn) {
            return MainScreen();
          } else {
            return LandingPage(); 
          }
        },
      ),
    );
  }
}