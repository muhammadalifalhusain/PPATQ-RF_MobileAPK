import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../models/berita_model.dart';
import '../screens/detail_berita.dart';

class BeritaScreen extends StatefulWidget {
  final List<BeritaItem> beritaList;
  final VoidCallback? onReachEnd;

  const BeritaScreen({
    Key? key,
    required this.beritaList,
    this.onReachEnd,
  }) : super(key: key);

  @override
  _BeritaScreenState createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final beritaList = widget.beritaList;

    if (beritaList.length < 2) {
      return const SizedBox.shrink();
    }

    return CarouselSlider.builder(
      itemCount: beritaList.length,
      itemBuilder: (context, index, realIndex) {
        final berita = beritaList[index];
        final String thumbnailUrl = (berita.thumbnail.isNotEmpty)
            ? (berita.thumbnail.startsWith('http')
                ? berita.thumbnail
                : 'https://manajemen.ppatq-rf.id/assets/img/upload/berita/thumbnail/${berita.thumbnail}')
            : 'https://via.placeholder.com/400x300.png?text=No+Image';

        final String judul = (berita.judul.trim().isEmpty)
            ? 'Judul tidak tersedia'
            : berita.judul;

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailBeritaScreen(berita: berita),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.4,
        autoPlay: false,
        initialPage: 0,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
          if (widget.onReachEnd != null &&
              index >= widget.beritaList.length - 2) {
            widget.onReachEnd!();
          }
        },
      ),
    );
  }
}
