import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

import '../../models/login_model.dart';

import '../../widgets/menu_dashboard_widget.dart';

import 'saku_keluar_screen.dart';
import 'saku_masuk_screen.dart';
import 'riwayat_bayar_screen.dart';

class ProfileDashboard extends StatefulWidget {
  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  LoginResponse? _loginData;

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }
  Future<void> _loadLoginData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _loginData = authProvider.loginResponse;
      });
    } catch (e) {
      print('Pesan error: $e');
    }
  }

  String formatKosong(String? value) {
    final cleaned = value?.replaceAll(',', '').trim() ?? '';
    return cleaned.isNotEmpty ? value!.trim() : '-';
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.teal,
      elevation: 1,
      toolbarHeight: 48,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Profile',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Spacer(), 
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              'V1.1.20',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    body: _loginData == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 132, 123, 123),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                
                                Transform.translate(
                                  offset: Offset(0, -25), 
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 45, // Diperkecil dari 60 ke 45
                                          backgroundColor: Colors.grey.shade100,
                                          backgroundImage: (_loginData?.photo.isNotEmpty ?? false)
                                              ? NetworkImage(
                                                  'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${_loginData?.photo}')
                                              : null,
                                          child: (_loginData?.photo.isEmpty ?? true)
                                              ? Icon(
                                                  Icons.person,
                                                  size: 32,
                                                  color: Colors.grey[400],
                                                )
                                              : null,
                                        ),
                                      ),                                      
                                      SizedBox(height: 8),
                                      Text(
                                        _loginData?.nama ?? 'Nama Tidak Tersedia',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade800,
                                          letterSpacing: 0.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -18), 
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color.fromARGB(255, 132, 123, 123),
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(255, 131, 51, 51).withOpacity(0.08),
                                          spreadRadius: 4,
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Kelas: ${_loginData?.kelas ?? 'Tidak Tersedia'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'NIS: ${_loginData?.noInduk ?? 'Tidak Tersedia'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.teal.shade600,
                                  Colors.teal.shade700,
                                  Colors.teal.shade800,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -30,
                                  right: -30,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  left: -20,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Saldo Uang Saku',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Rp ${_formatRupiah(_loginData?.keuangan.saldo ?? 0)}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.5,
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),                        
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => SakuMasukScreen()));
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.green.shade400, Colors.green.shade600],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Saldo Masuk',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Rp ${_formatRupiah(_loginData?.keuangan.totalSakuMasuk ?? 0)}',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Bulan ini',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Detail',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white.withOpacity(0.9),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: Colors.white.withOpacity(0.9),
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => SakuKeluarScreen()));
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.red.shade400, Colors.red.shade600],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Saldo Keluar',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Rp ${_formatRupiah(_loginData?.keuangan.totalSakuKeluar ?? 0)}',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Bulan ini',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Detail',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white.withOpacity(0.9),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: Colors.white.withOpacity(0.9),
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RiwayatPembayaranScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 132, 123, 123),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history, color: Colors.white, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'Riwayat Pembayaran Pondok',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),              
                MenuGrid(),
                Padding(
                  padding: EdgeInsets.all(15), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
                          child: Text(
                            'Informasi Santri',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      _buildInfoItem(
                        Icons.person,
                        'Murroby',
                        '${formatKosong(_loginData?.namaMurroby)} - Kamar : ${formatKosong(_loginData?.kamar)}',
                      ),
                      _buildInfoItem(
                        Icons.person,
                        'Ustadz',
                        '${formatKosong(_loginData?.namaUstadTahfidz)} - ${formatKosong(_loginData?.kelasTahfidz)}',
                      ),
                      _buildInfoItem(
                        Icons.home,
                        'Alamat',
                        formatKosong(_loginData?.alamat),
                      ),
                      _buildInfoItem(
                        Icons.calendar_month,
                        'Tgl-Lahir',
                        formatKosong(_loginData?.tanggalLahir),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: ExpansionTile(
                      title: Text(
                        'Data Ortu',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5), 
                      children: [
                        _buildTextRow('Nama Ayah', formatKosong(_loginData?.namaAyah)),
                        _buildTextRow('Pendidikan', formatKosong(_loginData?.pendidikanAyah)),
                        _buildTextRow('Pekerjaan', formatKosong(_loginData?.pekerjaanAyah)),
                        _buildTextRow('Nama Ibu', formatKosong(_loginData?.namaIbu)),
                        _buildTextRow('Pendidikan', formatKosong(_loginData?.pendidikanIbu)),
                        _buildTextRow('Pekerjaan', formatKosong(_loginData?.pekerjaanIbu)),
                        _buildTextRow('No Ortu', formatKosong(_loginData?.noHp)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildInfoItem(IconData icon, String label, String value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: Colors.teal),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
}