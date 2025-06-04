import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

import '../screens/murroby/login_screen.dart';
import '../screens/konfirmasi_login_screen.dart';

// import '../screens/register_screen.dart';

class AppHeader extends StatelessWidget {
  final bool showBackButton;
  final bool showAuthButtons;

  const AppHeader({
    Key? key,
    this.showBackButton = false,
    this.showAuthButtons = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // BAGIAN ATAS: Logo + Back button
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset('assets/images/logo.png', height: 80),
              ),
              if (showBackButton)
                Positioned(
                  top: 0,
                  left: -10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: 25),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),

          // Judul
          Text(
            'PPATQ RAUDLATUL FALAH',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),

          // Deskripsi
          Text(
            'Pondok Pesantren Anak-anak Tahfidzul Qur\'an Raudlatul Falah – Pati',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),

          // Tombol Login/Register (hanya tampil jika showAuthButtons == true)
          if (showAuthButtons)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.login, size: 23, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => KonfirmasiLoginScreen()),
                      );
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.person_add, size: 23, color: Colors.white),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => RegisterScreen()),
                  //     );
                  //   },
                  // ),
                ],
              ),
            )
          else
            SizedBox(height: 45), // Placeholder untuk menjaga tinggi tetap (opsional)
        ],
      ),
    );
  }
}
