import 'package:flutter/material.dart';
import '../models/berita_model.dart';

class DetailBeritaPage extends StatelessWidget {
  final Berita berita;

  const DetailBeritaPage({required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(berita.judul)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(berita.thumbnail, width: double.infinity, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16.0),
            Text(berita.judul, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(berita.isiBerita, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
