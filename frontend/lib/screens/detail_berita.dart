import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/berita_model.dart';
import 'package:google_fonts/google_fonts.dart';
class DetailBeritaScreen extends StatelessWidget {
  final BeritaItem berita;

  const DetailBeritaScreen ({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    final String baseImageUrl = "https://manajemen.ppatq-rf.id/assets/img/upload/berita/thumbnail/";
    final String? gambarDalam = berita.gambarDalam?.isNotEmpty == true ? berita.gambarDalam : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        toolbarHeight: 56,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Detail Berita',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              berita.judul,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
                
              ),
            ),
            const SizedBox(height: 16),

            // Gambar Dalam
            if (gambarDalam != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '$baseImageUrl$gambarDalam',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    height: 200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                  ),
                ),
              ),

            if (gambarDalam != null) const SizedBox(height: 20),

            Html(
              data: berita.isiBerita,
              onLinkTap: (url, _, __) async {
                if (url != null) {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint("Tidak dapat membuka link: $url");
                  }
                }
              },
              style: {
                "p": Style(
                  fontSize: FontSize.medium,
                  lineHeight: LineHeight.number(1.5),
                  padding: HtmlPaddings.zero,
                  margin: Margins.zero,
                  fontFamily: 'Poppins',
                ),
                "body": Style(
                  fontFamily: 'Poppins',
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
