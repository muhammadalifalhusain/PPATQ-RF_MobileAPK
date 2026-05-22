import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PspInfoCard extends StatelessWidget {
  const PspInfoCard({super.key});

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=id.co.solusinegeri.pspEdmedia&pcampaignid=web_share';

  Future<void> _openPlayStore() async {
    final uri = Uri.parse(_playStoreUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _openPlayStore,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [

              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Info Keuangan ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            'gunakan PSP Mobile',
                      ),
                    ],
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}