import 'package:flutter/material.dart';
import 'login_screen.dart';
import './murroby/login_screen.dart';
import 'landing_page.dart';

class KonfirmasiLoginScreen extends StatelessWidget {
  const KonfirmasiLoginScreen({Key? key}) : super(key: key);

  void _navigateToRole(BuildContext context, String role) {
    Widget nextPage;
    if (role == 'wali') {
      nextPage = LoginScreen();
    } else {
      nextPage = LoginScreenMurroby();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00695C), Color(0xFF004D40), Color(0xFF00251A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LandingPage()),
                      );
                    },
                  ),
                ),
              ),

              // Logo & Title
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/logo.png', height: 80),
                        SizedBox(height: 24),
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'PPATQ RAUDLATUL FALAH',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 40),

                        // Tombol Login Wali Santri
                        ElevatedButton(
                          onPressed: () => _navigateToRole(context, 'wali'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF00695C),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text('WalSan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 20),

                        // Tombol Login Murroby
                        ElevatedButton(
                          onPressed: () => _navigateToRole(context, 'murroby'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF00695C),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text('Murroby', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'PPATQ RAUDLATUL FALAH',
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Copyright © 2025 All Rights Reserved',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
