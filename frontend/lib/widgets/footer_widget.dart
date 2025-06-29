import 'package:flutter/material.dart';
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
        const Text(
          'PPATQ RAUDLATUL FALAH',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const Text(
          'Copyright © 2025 All Rights Reserved-V.25.6',
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
