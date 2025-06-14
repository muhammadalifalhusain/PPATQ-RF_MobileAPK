import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(quran.getSurahName(18)),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: quran.getVerseCount(18),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    quran.getVerse(18, index + 1, verseEndSymbol: true),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.amiri(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}