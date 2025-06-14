import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformasiScreen extends StatelessWidget {
  const InformasiScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchWhatsApp(String number) async {
    final url = "https://wa.me/$number";
    await _launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mekanisme Pembayaran Syahriah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Waktu Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Pembayaran syahriah wajib dilakukan pada tanggal 1-10 setiap bulannya.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            
            const Text(
              '2. Rekening Tujuan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text('Bank Syariah Indonesia (BSI)'),
            const Text('Kode bank: 451'),
            const Text('Nomor rekening: 7141299818'),
            const Text('Nama pemilik rekening: Ponpes Anak Tahfidul Qur\'an RF'),
            const SizedBox(height: 20),
            
            const Text(
              '3. Cara Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'a. Transfer ke rekening tujuan sesuai rincian yang sudah dipersiapkan sebelumnya. '
              'Kemudian laporkan pembayaran melalui aplikasi PPATQ-RF ku dengan menyertakan bukti transfer.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              'b. Rencanakan item-item yang akan dibayarkan termasuk tunggakan melalui aplikasi mobile PPATQ-RF ku.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            
            const Text(
              '4. Lapor Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            GestureDetector(
              onTap: () => _launchUrl('http://payment.ppatq-rf.id'),
              child: const Text(
                'Anda dapat melapor melalui: https://payment.ppatq-rf.id',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const Text(
              'Anda akan menerima konfirmasi via WhatsApp setelah melapor.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            
            const Text(
              '5. Laporan Bukti Bayar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Lapor bukti bayar untuk memudahkan pemetaan data dan verifikasi antara pondok dengan wali santri.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            
            const Text(
              '6. Uang Saku',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Monitor uang saku santri melalui menu uang saku di aplikasi.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            
            const Text(
              '7. Layanan Informasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text('a. Informasi pembayaran:'),
            GestureDetector(
              onTap: () => _launchWhatsApp('6287767572025'),
              child: const Text(
                '0877-6757-2025',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 10),
            const Text('b. Bantuan teknis aplikasi:'),
            GestureDetector(
              onTap: () => _launchWhatsApp('62818240102'),
              child: const Text(
                '0818.24.0102',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 30),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman lapor bayar
                  Navigator.pushNamed(context, '/lapor-bayar');
                },
                child: const Text('Lapor Pembayaran Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}