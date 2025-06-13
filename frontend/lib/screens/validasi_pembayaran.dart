import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'pembayaran_screen.dart';

class ValidasiPembayaranScreen extends StatelessWidget {
  const ValidasiPembayaranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Konfirmasi Pembayaran',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.circleCheck,
              size: 120,
              color: Colors.blue.shade300,
            ),
            const SizedBox(height: 32),
            Text(
              'Apakah Anda sudah melakukan pembayaran?',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildConfirmationButton(
              context,
              title: 'Sudah Bayar',
              icon: FontAwesomeIcons.check,
              color: Colors.green,
              onPressed: () => _handleConfirmation(context, true),
            ),
            const SizedBox(height: 16),
            _buildConfirmationButton(
              context,
              title: 'Belum Bayar',
              icon: FontAwesomeIcons.clock,
              color: Colors.orange,
              onPressed: () => InputPembayaranScreen(),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                // Aksi untuk bantuan/tanya admin
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

  void _handleConfirmation(BuildContext context, bool isConfirmed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isConfirmed ? 'Sudah Bayar' : 'Belum Bayar',
          style: GoogleFonts.poppins(),
        ),
        content: Text(
          isConfirmed
              ? 'Terima kasih telah mengkonfirmasi pembayaran. Kami akan segera memverifikasi pembayaran Anda.'
              : 'Silakan lakukan pembayaran terlebih dahulu untuk melanjutkan.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isConfirmed) {
                // Navigasi ke screen verifikasi
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputPembayaranScreen(),
                  ),
                );
              }
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
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
              'Hubungi admin melalui:',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                'Telepon: 0812-3456-7890',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                // Implementasi panggilan telepon
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                'Email: admin@example.com',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                // Implementasi pengiriman email
                Navigator.pop(context);
              },
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

// Screen verifikasi pembayaran (contoh sederhana)
class PaymentVerificationScreen extends StatelessWidget {
  const PaymentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi Pembayaran',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.clockRotateLeft,
              size: 60,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Pembayaran sedang diverifikasi...',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}