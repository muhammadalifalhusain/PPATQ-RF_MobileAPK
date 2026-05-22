import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login_screen.dart';

class AppHeader extends StatelessWidget {
  final bool isScrolled;
  final bool showBackButton;

  const AppHeader({
    super.key,
    this.isScrolled = false,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool darkMode = isScrolled;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 18,
        right: 18,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: darkMode
            ? const Color(0xFF003B46)
            : Colors.white,
        boxShadow: darkMode
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: darkMode
                    ? Colors.white
                    : const Color(0xFF003B46),
              ),
            ),

          /// Logo + Text
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 34,
                ),
                const SizedBox(width: 10),
                Text(
                  'PPATQ-RF',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: darkMode
                        ? Colors.white
                        : const Color(0xFF003B46),
                  ),
                ),
              ],
            ),
          ),

          /// Login Button
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: darkMode
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: darkMode
                      ? Colors.white24
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: darkMode
                      ? Colors.white
                      : const Color(0xFF003B46),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}