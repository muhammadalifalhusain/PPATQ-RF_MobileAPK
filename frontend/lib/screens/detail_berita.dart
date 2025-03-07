import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/berita_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBeritaPage extends StatelessWidget {
  final Berita berita;

  const DetailBeritaPage({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(berita.judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              berita.thumbnail,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 200),
            ),
            const SizedBox(height: 16.0),

            Text(
              berita.judul,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),

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
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
