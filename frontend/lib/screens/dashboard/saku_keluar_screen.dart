import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/keuangan_service.dart';
import '../../models/keuangan_model.dart';

class SakuKeluarScreen extends StatefulWidget {
  const SakuKeluarScreen({super.key});

  @override
  State<SakuKeluarScreen> createState() => _SakuKeluarScreenState();
}

class _SakuKeluarScreenState extends State<SakuKeluarScreen> {
  final KeuanganService _service = KeuanganService();
  UangResponse? _data;
  bool _isLoading = true;
  String? _expandedYear;
  String? _expandedMonth;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getSakuKeluar();
      setState(() {
        _data = data;
        _isLoading = false;
        _initExpandedMonths();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data: ${e.toString()}',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  /// Semua kartu tertutup secara default
  void _initExpandedMonths() {
    _expandedYear = null;
    _expandedMonth = null;
  }

  String _formatCurrency(dynamic amount) {
    int number = 0;
    if (amount is int) number = amount;
    else if (amount is String) number = int.tryParse(amount) ?? 0;
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  int _calculateTotal() {
    if (_data?.data?.dataUangKeluar == null) return 0;
    int total = 0;
    _data!.data!.dataUangKeluar!.forEach((_, bulanMap) {
      bulanMap.forEach((_, list) {
        for (var trx in list) {
          total += trx.jumlahKeluar ?? 0;
        }
      });
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Saku Keluar',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        )),
      ),
      body: _isLoading
      ? _buildLoading()
      : _data?.data?.dataUangKeluar == null
      ? _buildEmpty()
      : RefreshIndicator(
          onRefresh: _loadData,
          color: Colors.red.shade400,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryCard(total),
              const SizedBox(height: 10),
              Text('Riwayat Saku Keluar',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800)),
              const SizedBox(height: 12),
              ..._buildExpandableData(),
            ],
          ),
        ),
    );
  }

  Widget _buildLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.red.shade400)),
            const SizedBox(height: 16),
            Text('Memuat data...',
                style:
                    GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16))
          ],
        ),
      );

  Widget _buildEmpty() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Belum ada transaksi keluar',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text('Transaksi uang keluar akan muncul di sini',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500)),
          ],
        ),
      );

  Widget _buildSummaryCard(int total) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade600, Colors.orange.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Saku Keluar',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text('Rp ${_formatCurrency(total)}',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  List<Widget> _buildExpandableData() {
    final tahunList = _data!.data!.dataUangKeluar!.keys.toList()..sort();
    return tahunList.map((tahun) {
      final bulanMap = _data!.data!.dataUangKeluar![tahun]!;
      final bulanList = bulanMap.keys.toList()..sort();
      final isYearExpanded = _expandedYear == tahun;

      return ExpansionTile(
        key: PageStorageKey('year_$tahun'),
        initiallyExpanded: isYearExpanded,
        title: Text(tahun,
            style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade700)),
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              _expandedYear = tahun;
            } else if (_expandedYear == tahun) {
              _expandedYear = null;
              _expandedMonth = null;
            }
          });
        },
        children: bulanList.map((bulan) {
          final isMonthExpanded = isYearExpanded && _expandedMonth == bulan;
          
          return ExpansionTile(
            key: PageStorageKey('month_${tahun}_$bulan'),
            initiallyExpanded: isMonthExpanded,
            title: Text(
              bulan,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, color: Colors.grey.shade800),
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                if (expanded) {
                  _expandedYear = tahun;
                  _expandedMonth = bulan;
                } else if (_expandedMonth == bulan) {
                  _expandedMonth = null;
                }
              });
            },
            children: bulanMap[bulan]!.map((trx) {
              return ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.trending_down,
                      color: Colors.red.shade400, size: 22),
                ),
                title: Text(
                    trx.catatan?.isNotEmpty == true
                        ? trx.catatan!
                        : 'Pengeluaran',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                subtitle: Text(_formatDate(trx.tanggalTransaksi ?? '-'),
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade600)),
                trailing: Text(
                  '-Rp ${_formatCurrency(trx.jumlahKeluar)}',
                  style: GoogleFonts.poppins(
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();
  }
}