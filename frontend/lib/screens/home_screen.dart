import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Home", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          "Ini adalah Home Screen",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
