import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/models/tutorial_pembayaran_model.dart';
import 'package:frontend/services/tutorial_pembayaran_service.dart';
import '../widgets/loading_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class InformasiScreen extends StatefulWidget {
  const InformasiScreen({Key? key}) : super(key: key);

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  List<TutorialPembayaran> tutorialList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTutorialPembayaran();
  }

  Future<void> _loadTutorialPembayaran() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final tutorials = await InfoPembayaranService.fetchTutorialPembayaran();
      tutorials.sort((a, b) => a.urutan.compareTo(b.urutan));

      setState(() {
        tutorialList = tutorials;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildTutorialCard(TutorialPembayaran tutorial) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${tutorial.urutan}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Html(
              data: tutorial.teks,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize(16),
                  fontFamily: GoogleFonts.poppins().fontFamily, 
                ),
                "div": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontFamily: GoogleFonts.poppins().fontFamily, 
                  
                ),
                "br": Style(
                  margin: Margins.only(bottom: 4),
                ),
                "a": Style(
                  color: Colors.teal,
                  textDecoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily, 
                  
                ),
              },
              onLinkTap: (url, attributes, element) {
                if (url != null) {
                  _launchUrl(url);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Terjadi kesalahan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadTutorialPembayaran,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada tutorial',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tutorial pembayaran tidak tersedia',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            'Informasi',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const LoadingScreen(
                message: 'Memuat data Informasi...',
                backgroundColor: Colors.teal,
                progressColor: Colors.white,
                icon: FontAwesomeIcons.circleInfo,
              )
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : tutorialList.isEmpty
                  ? _buildEmptyWidget()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: tutorialList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return _buildTutorialCard(tutorialList[index]);
                      },
                    ),
    );
  }
}