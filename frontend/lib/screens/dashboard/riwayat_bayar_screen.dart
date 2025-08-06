import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/riwayat_bayar_service.dart';
import '../../models/riwayat_bayar_model.dart';

class RiwayatPembayaranScreen extends StatefulWidget {
  const RiwayatPembayaranScreen({super.key});

  @override
  State<RiwayatPembayaranScreen> createState() =>
      _RiwayatPembayaranScreenState();
}

class _RiwayatPembayaranScreenState extends State<RiwayatPembayaranScreen> {
  late Future<RiwayatBayarResponse> _riwayatFuture;
  final RiwayatBayarService _service = RiwayatBayarService();
  List<bool> _isExpandedList = [];

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
        elevation: 2,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Riwayat',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
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
          } else if (!snapshot.hasData ||
              snapshot.data!.data.transaksi.isEmpty) {
            return const Center(child: Text('Tidak ada data riwayat pembayaran'));
          }

          final data = snapshot.data!.data;
          final jenisPembayaran = data.jenisPembayaran;
          final transaksi = data.transaksi;

          if (_isExpandedList.isEmpty) {
            _isExpandedList =
                List.generate(transaksi.length, (index) => index == 0);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: transaksi.asMap().entries.map((entry) {
                final index = entry.key;
                final trx = entry.value;
                return _buildTransactionCard(
                  trx,
                  jenisPembayaran,
                  index,
                  _isExpandedList[index],
                  (bool expand) {
                    setState(() {
                      _isExpandedList =
                          _isExpandedList.map((_) => false).toList();
                      _isExpandedList[index] = expand;
                    });
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(
    TransaksiPembayaran trx,
    List<JenisPembayaran> jenisPembayaran,
    int index,
    bool isExpanded,
    Function(bool) onToggle,
  ) {
    final totalBayar = jenisPembayaran.fold<double>(
      0,
      (sum, jenis) => sum + trx.getNumericPayment(jenis.id),
    );

    final currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    final bool isBelumValid = trx.validasi == 'Belum di Validasi';
    final String statusText = isBelumValid ? 'belum Valid' : 'Valid';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => onToggle(!isExpanded),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        trx.tanggalBayar,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey[700],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isBelumValid ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (isExpanded) ...[
                const SizedBox(height: 12),
                _buildDetailItem("Periode", trx.periode),
                const Divider(),
                ...jenisPembayaran
                    .where((jenis) => trx.getNumericPayment(jenis.id) > 0)
                    .map((jenis) => _buildPaymentItem(jenis, trx)),
                const Divider(),
                _buildDetailItem(
                    "Total", currencyFormat.format(totalBayar)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentItem(JenisPembayaran jenis, TransaksiPembayaran trx) {
    return _buildDetailItem(
      jenis.jenis,
      'Rp ${trx.getFormattedPayment(jenis.id)}',
    );
  }

  Widget _buildDetailItem(String label, String value) {
    final bool isEmpty = value.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isEmpty ? Colors.grey[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isEmpty ? 'Tidak ada catatan' : value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                  fontStyle:
                      isEmpty ? FontStyle.italic : FontStyle.normal,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
