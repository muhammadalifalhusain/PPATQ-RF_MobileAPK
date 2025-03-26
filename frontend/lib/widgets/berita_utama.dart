import 'package:flutter/material.dart';
import '../models/berita_model.dart';
import '../screens/detail_berita.dart';

class BeritaUtama extends StatelessWidget {
  final Berita berita;

  BeritaUtama({required this.berita});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // agar rata kiri untuk paragraf bawah
      children: [
        // Judul berita
        Padding(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  child: Text(
    berita.judul,
    style: TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.03, // Ukuran font dinamis
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    textAlign: TextAlign.center,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  ),
),

        // Thumbnail gambar
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailBeritaPage(berita: berita)),
          ),
          child: Container(
            width: double.infinity, // Full width
            height: 200, // Tinggi sesuai yang ada di DetailBeritaPage
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Jika mau tetap rounded
              color: Colors.grey[200], // Warna latar belakang jika gambar tidak memenuhi container
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Jika mau tetap rounded
              child: Image.network(
                berita.thumbnail,
                fit: BoxFit.contain, // Menggunakan BoxFit.contain agar gambar tidak terpotong
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 200),
              ),
            ),
          ),
        ),
        SizedBox(height: 10), // Jarak bawah
      ],
    );
  }
}