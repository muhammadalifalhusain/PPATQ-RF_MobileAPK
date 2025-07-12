import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10), 
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Text(
                'v.04.7c',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset('assets/images/logo.png', height: 60), 
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
          
          SizedBox(height: 4), 
          Text(
          'Pondok Pesantren Anak-anak Tahfidzul Qur\'an Raudlatul Falah - Pati',
          style: GoogleFonts.poppins( 
            fontSize: 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
          SizedBox(height: 10), 
          if (showAuthButtons)
          
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.login, size: 16, color: Colors.white),
                    label: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            )
          else
            SizedBox(height: 5),
        ],
      ),
    );
  }
}