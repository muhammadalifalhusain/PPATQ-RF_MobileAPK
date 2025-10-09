import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/keuangan_service.dart';
import '../../models/keuangan_model.dart';

class SakuMasukScreen extends StatefulWidget {
  @override
  _SakuMasukScreenState createState() => _SakuMasukScreenState();
}

class _SakuMasukScreenState extends State<SakuMasukScreen> {
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
      final data = await _service.getSakuMasuk();
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

  /// Tahun terakhir terbuka menampilkan list bulan, tapi bulan tertutup semua
  void _initExpandedMonths() {
    if (_data?.data?.dataUangMasuk == null) return;

    final tahunKeys = _data!.data!.dataUangMasuk!.keys.toList()..sort();
    if (tahunKeys.isNotEmpty) {
      _expandedYear = tahunKeys.last;
    }
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
    if (_data?.data?.dataUangMasuk == null) return 0;
    int total = 0;
    _data!.data!.dataUangMasuk!.forEach((_, bulanMap) {
      bulanMap.forEach((_, list) {
        for (var trx in list) {
          total += int.tryParse(trx.jumlahMasuk.toString()) ?? 0;
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
        title: Text('Saku Masuk',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        )),
      ),
      body: _isLoading
      ? _buildLoading()
      : _data?.data?.dataUangMasuk == null
      ? _buildEmpty()
      : RefreshIndicator(
          onRefresh: _loadData,
          color: Colors.teal.shade400,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryCard(total),
              const SizedBox(height: 20),
              Text('Riwayat Saku Masuk',
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
                    AlwaysStoppedAnimation<Color>(Colors.green.shade400)),
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
            Text('Belum ada transaksi masuk',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text('Transaksi uang masuk akan muncul di sini',
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
            colors: [Colors.green.shade400, Colors.teal.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade200.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Saku Masuk',
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
    final tahunList = _data!.data!.dataUangMasuk!.keys.toList()..sort();
    
    return tahunList.map((tahun) {
      final bulanMap = _data!.data!.dataUangMasuk![tahun]!;
      final bulanList = bulanMap.keys.toList()..sort();
      final isYearExpanded = _expandedYear == tahun;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: isYearExpanded ? Colors.teal.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isYearExpanded ? Colors.teal.shade200 : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isYearExpanded 
                    ? Colors.teal.shade100.withOpacity(0.3)
                    : Colors.grey.shade200.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: PageStorageKey('year_$tahun'),
              initiallyExpanded: isYearExpanded,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isYearExpanded ? Colors.teal.shade400 : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                tahun,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isYearExpanded ? Colors.teal.shade700 : Colors.grey.shade700,
                ),
              ),
              trailing: Icon(
                isYearExpanded ? Icons.expand_less : Icons.expand_more,
                color: isYearExpanded ? Colors.teal.shade600 : Colors.grey.shade600,
              ),
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
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMonthExpanded ? Colors.green.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isMonthExpanded ? Colors.green.shade200 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        key: PageStorageKey('month_${tahun}_$bulan'),
                        initiallyExpanded: isMonthExpanded,
                        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isMonthExpanded ? Colors.green.shade100 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.date_range,
                            color: isMonthExpanded ? Colors.green.shade600 : Colors.grey.shade600,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          bulan,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: isMonthExpanded ? Colors.green.shade700 : Colors.grey.shade800,
                          ),
                        ),
                        trailing: Icon(
                          isMonthExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                          color: isMonthExpanded ? Colors.green.shade600 : Colors.grey.shade500,
                          size: 20,
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
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.green.shade400, Colors.teal.shade300],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.shade200.withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              title: Text(
                                trx.uangAsal ?? '-',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                _formatDate(trx.tanggalTransaksi ?? '-'),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              trailing: Text(
                                '+Rp ${_formatCurrency(trx.jumlahMasuk)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }).toList();
  }
}