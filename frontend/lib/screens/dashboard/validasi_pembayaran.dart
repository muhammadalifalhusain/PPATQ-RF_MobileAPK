import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dashboard/main.dart';

import 'pembayaran_screen.dart';

class ValidasiPembayaranScreen extends StatelessWidget {
  const ValidasiPembayaranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        toolbarHeight: 56,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Konfirmasi',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.circleCheck,
              size: 120,
              color: Colors.blue.shade300,
            ),
            const SizedBox(height: 10),
            Text(
              '" Lapor bukti bayar ini adalah Upaya memudahkan pemetaan data bayar sesuai dengan keperuntukannya sekaligus double check antara Lembaga pondok dengan wali santri "',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70),
            Text(
              'Apakah Anda sudah melakukan pembayaran?',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: FaIcon(FontAwesomeIcons.check, size: 20),
                label: Text(
                  'Sudah Bayar',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputPembayaranScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.green, width: 1.5),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildConfirmationButton(
              context,
              title: 'Belum Bayar',
              icon: FontAwesomeIcons.clock,
              color: Colors.orange,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                _showHelpDialog(context);
              },
              child: Text(
                'Butuh bantuan? Hubungi Admin',
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: FaIcon(icon, size: 20),
        label: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color, width: 1.5),
          ),
          elevation: 0,
        ),
      ),
    );
  }





  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Bantuan Pembayaran',
          style: GoogleFonts.poppins(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tekan untuk lanjut ke WhatsApp :',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12), 
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: Text(
                  'Telepon: +6287767572025',
                  style: GoogleFonts.poppins(
                    color: Colors.green[900], 
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  final whatsappUrl = Uri.parse("https://wa.me/6287767572025");
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Tidak dapat membuka WhatsApp';
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}