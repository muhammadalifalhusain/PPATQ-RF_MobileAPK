import 'package:flutter/material.dart';
import '../models/berita_model.dart';

class BeritaCard extends StatelessWidget {
  final Berita berita;
  final VoidCallback onTap;

  const BeritaCard({required this.berita, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(berita.thumbnail, width: double.infinity, height: 150, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(berita.judul, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
