import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/berita_model.dart';
import '../screens/detail_berita.dart';
import 'package:html/parser.dart' as html_parser;

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

    return Container(
      margin: const EdgeInsets.only(bottom: 26.0),
      child: CarouselSlider.builder(
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

          final String isiBeritaRaw =
              (berita.isiBerita.trim().isNotEmpty) ? berita.isiBerita : '';
          final String isiBeritaText =
              html_parser.parse(isiBeritaRaw).body?.text ?? '';
          final String isiBerita = (isiBeritaText.length > 120)
              ? '${isiBeritaText.substring(0, 120)}...'
              : isiBeritaText;

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailBeritaScreen(berita: berita),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.network(
                      thumbnailUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: const Icon(Icons.broken_image,
                            size: 50, color: Colors.grey),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              judul,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            if (isiBerita.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 2.0),
                                child: Text(
                                  isiBerita,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
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
      ),
    );
  }
}
