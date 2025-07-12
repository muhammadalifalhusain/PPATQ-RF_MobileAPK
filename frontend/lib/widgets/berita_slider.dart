import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../models/berita_model.dart';
import '../screens/detail_berita.dart';

class BeritaSlider extends StatefulWidget {
  final List<BeritaItem> beritaList;
  final VoidCallback? onReachEnd;

  const BeritaSlider({
    Key? key,
    required this.beritaList,
    this.onReachEnd,
  }) : super(key: key);

  @override
  _BeritaSliderState createState() => _BeritaSliderState();
}

class _BeritaSliderState extends State<BeritaSlider> {
  int _currentIndex = 0;
  bool _hasReachedEnd = false;

  @override
  Widget build(BuildContext context) {
    final beritaList = widget.beritaList;

    if (beritaList.length <= 1) {
      return const SizedBox.shrink();
    }

    return CarouselSlider.builder(
      itemCount: beritaList.length,
      itemBuilder: (context, index, realIndex) {
        final berita = beritaList[index];
        final imageUrl =
            'https://manajemen.ppatq-rf.id/assets/img/upload/berita/thumbnail/${berita.thumbnail}';

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailBeritaPage(berita: berita),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  berita.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex >= 4 && !_hasReachedEnd) {
            _hasReachedEnd = true;
            if (widget.onReachEnd != null) {
              widget.onReachEnd!();
            }
          }
        },
      ),
    );
  }
}
