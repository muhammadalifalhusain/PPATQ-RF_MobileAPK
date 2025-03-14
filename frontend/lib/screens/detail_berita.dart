import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/berita_model.dart';
import '../widgets/footer_widget.dart';

class DetailBeritaPage extends StatelessWidget {
  final Berita berita;

  const DetailBeritaPage({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {
              print('Berbagi berita: ${berita.judul}');
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark, color: Colors.black),
            onPressed: () {
              print('Menyimpan berita: ${berita.judul}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0, bottom: 16.0), // Padding atas ditambah
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                berita.judul,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    '12 Oktober 2023', 
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    'Admin', 
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Html(
                data: berita.isiBerita,
                onLinkTap: (url, attributes, element) async {
                  if (url != null) {
                    final Uri uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      print("Tidak dapat membuka link: $url");
                    }
                  }
                },
                style: {
                  "p": Style(
                    fontSize: FontSize.medium,
                    lineHeight: LineHeight.number(1.5),
                    padding: HtmlPaddings.zero,
                    margin: Margins.zero,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}