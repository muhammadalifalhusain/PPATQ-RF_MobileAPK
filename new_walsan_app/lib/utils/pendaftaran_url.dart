import 'package:url_launcher/url_launcher.dart';

Future<void> launchPSBUrl() async {
  final Uri url = Uri.parse('http://psb.ppatq-rf.id');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
