import 'package:flutter/material.dart';
import '../models/berita_model.dart';
import '../screens/detail_berita.dart';

class BeritaUtama extends StatelessWidget {
  final BeritaItem berita;

  BeritaUtama({required this.berita});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            berita.judul,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailBeritaScreen(berita: berita)),
          ),
          child: Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://manajemen.ppatq-rf.id/assets/img/upload/berita/thumbnail/${berita.thumbnail}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
