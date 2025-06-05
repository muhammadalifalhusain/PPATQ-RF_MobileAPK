import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  Future<void> _launchWithFallback(String primaryUrl, String fallbackUrl) async {
    final Uri primaryUri = Uri.parse(primaryUrl);
    if (await canLaunchUrl(primaryUri)) {
      await launchUrl(primaryUri, mode: LaunchMode.externalApplication);
    } else {
      final Uri fallbackUri = Uri.parse(fallbackUrl);
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $fallbackUrl';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.tiktok, color: Colors.black),
              tooltip: 'TikTok',
              onPressed: () => _launchWithFallback(
                "tiktok://user/@ppatq.raudlatulfalah", // URI scheme (jika app tersedia)
                "https://www.tiktok.com/@ppatq.raudlatulfalah?lang=en", // Fallback ke browser
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
              tooltip: 'Facebook',
              onPressed: () => _launchWithFallback(
                "fb://facewebmodal/f?href=https://www.facebook.com/pprtq.r.falah", // Facebook app
                "https://www.facebook.com/pprtq.r.falah", // Fallback
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
              tooltip: 'Instagram',
              onPressed: () => _launchWithFallback(
                "instagram://user?username=ppatq_raudlatulfalah", // Instagram app
                "https://www.instagram.com/ppatq_raudlatulfalah", // Fallback
              ),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Colors.red),
              tooltip: 'Google Maps',
              onPressed: () => _launchWithFallback(
                "geo:0,0?q=PPATQ+Raudlatul+Falah", // Maps app
                "https://maps.app.goo.gl/WJxpAMFN8htranSa8", // Fallback
              ),
            ),
          ],
        ),
        const Text(
          'PPATQ RAUDLATUL FALAH',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const Text(
          'Copyright © 2025 All Rights Reserved',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
