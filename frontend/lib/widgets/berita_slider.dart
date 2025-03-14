import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../models/berita_model.dart';
import '../screens/detail_berita.dart';

class BeritaSlider extends StatelessWidget {
  final List<Berita> beritaList;

  BeritaSlider({required this.beritaList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: beritaList.length,
      itemBuilder: (context, index, realIndex) {
        final berita = beritaList[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailBeritaPage(berita: berita)),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar dengan AspectRatio untuk memastikan rasio konsisten
                AspectRatio(
                  aspectRatio: 4 / 3, // Rasio 4:3
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        berita.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailBeritaPage(berita: berita)),
                    ),
                    icon: Icon(Icons.arrow_forward, color: Colors.black),
                    label: Text(
                      'Selengkapnya',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.4, // Tinggi carousel disesuaikan
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      ),
    );
  }
}