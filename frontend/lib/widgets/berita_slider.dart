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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: NetworkImage(berita.thumbnail), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(berita.judul, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Baca selengkapnya...', style: TextStyle(color: Colors.black54)),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.teal),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailBeritaPage(berita: berita))),
                ),
              ],
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.35,
        autoPlay: false,
        enlargeCenterPage: true,
      ),
    );
  }
}
