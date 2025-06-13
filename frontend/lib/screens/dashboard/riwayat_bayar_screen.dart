import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../services/riwayat_bayar_service.dart';
import '../../models/riwayat_bayar_model.dart';

class RiwayatPembayaranScreen extends StatefulWidget {
  const RiwayatPembayaranScreen({super.key});

  @override
  State<RiwayatPembayaranScreen> createState() => _RiwayatPembayaranScreenState();
}

class _RiwayatPembayaranScreenState extends State<RiwayatPembayaranScreen> {
  late Future<RiwayatBayarResponse> _riwayatFuture;
  final RiwayatBayarService _service = RiwayatBayarService();

  @override
  void initState() {
    super.initState();
    _riwayatFuture = _service.getRiwayatPembayaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 1,
        toolbarHeight: 48,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Riwayat Pembayaran',
            style: GoogleFonts.poppins( 
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: FutureBuilder<RiwayatBayarResponse>(
        future: _riwayatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.transaksi.isEmpty) {
            return const Center(child: Text('Tidak ada data riwayat pembayaran'));
          }

          final data = snapshot.data!.data;
          final jenisPembayaran = data.jenisPembayaran;
          final transaksi = data.transaksi;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...transaksi.map((trx) => _buildTransactionCard(trx, jenisPembayaran)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransaksiPembayaran trx, List<JenisPembayaran> jenisPembayaran) {
    final totalBayar = jenisPembayaran.fold<double>(
      0,
      (sum, jenis) => sum + trx.getNumericPayment(jenis.id),
    );

    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    trx.tanggalBayar,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: Tooltip(
                    message: trx.validasi,
                    child: Chip(
                      label: Text(
                        trx.validasi,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: trx.validasi == 'Belum di Validasi'
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      backgroundColor: trx.validasi == 'Belum di Validasi'
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Periode: ${trx.periode}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            const Divider(),
            ...jenisPembayaran
                .where((jenis) => trx.getNumericPayment(jenis.id) > 0)
                .map((jenis) => _buildPaymentItem(jenis, trx)),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(totalBayar),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(JenisPembayaran jenis, TransaksiPembayaran trx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(jenis.jenis),
          ),
          Text(
            'Rp ${trx.getFormattedPayment(jenis.id)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}