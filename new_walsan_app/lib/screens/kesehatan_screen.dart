import 'package:flutter/material.dart';
import '../models/kesehatan_model.dart';
import '../services/kesehatan_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/loading_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KesehatanScreen extends StatefulWidget {
  const KesehatanScreen({Key? key}) : super(key: key);

  @override
  _KesehatanScreenState createState() => _KesehatanScreenState();
}

class _KesehatanScreenState extends State<KesehatanScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  KesehatanData? kesehatanData;

  final List<Tab> _tabs = const [
    Tab(text: 'Kesehatan'),
    Tab(text: 'Pemeriksaan'),
    Tab(text: 'Rawat Inap'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await KesehatanService().getKesehatanData();
    setState(() {
      isLoading = false;
      kesehatanData = response.data; 
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: LoadingScreen(
          message: 'Mengambil data Kesehatan...',
          backgroundColor: Colors.teal,
          progressColor: Colors.white,
          icon: FontAwesomeIcons.hospital,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kesehatan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.teal,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14, 
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              isScrollable: false,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              tabs: _tabs.map((tab) {
                return Tab(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(tab.text!),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKesehatanTab(kesehatanData),
          _buildPemeriksaanTab(kesehatanData),
          _buildRawatInapTab(kesehatanData),
        ],
      ),
    );
  }

  Widget _buildKesehatanTab(KesehatanData? data) {
    if (data == null || data.riwayatSakit.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.healing_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data riwayat sakit',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat sakit santri akan muncul di sini',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.riwayatSakit.length,
      itemBuilder: (context, index) {
        final e = data.riwayatSakit[index];
        bool isCardExpanded = index == 0 && data.riwayatSakit.length > 1;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCardExpanded = !isCardExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.teal.shade800,
                                  Colors.teal.shade700,
                                  const Color.fromARGB(255, 53, 187, 171),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.healing, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Riwayat Sakit ke-${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            if (data.riwayatSakit.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.riwayatSakit.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.sick, 'Keluhan', e.keluhan),
                            _buildDataItem(Icons.event, 'Tanggal Sakit', e.tanggalSakit),
                            _buildDataItem(Icons.attractions, 'Tindakan', e.tindakan ?? '-'),
                            _buildDataItem(Icons.check_circle, 'Tanggal Sembuh', e.tanggalSembuh ?? '-'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPemeriksaanTab(KesehatanData? data) {
    if (data == null || data.pemeriksaan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data pemeriksaan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat pemeriksaan kesehatan akan muncul di sini',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.pemeriksaan.length,
      itemBuilder: (context, index) {
        final e = data.pemeriksaan[index];
        bool isCardExpanded = index == 0 && data.pemeriksaan.length > 1;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCardExpanded = !isCardExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.teal.shade800,
                                  Colors.teal.shade700,
                                  const Color.fromARGB(255, 53, 187, 171),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pemeriksaan ke-${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            if (data.pemeriksaan.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.pemeriksaan.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.calendar_today, 'Tanggal', e.tanggalPemeriksaan ?? '-'),
                            _buildDataItem(Icons.height, 'Tinggi Badan', '${e.tinggiBadan} cm'),
                            _buildDataItem(Icons.monitor_weight, 'Berat Badan', '${e.beratBadan} kg'),
                            _buildDataItem(Icons.straighten, 'Lingkar Pinggul', '${e.lingkarPinggul ?? '-'} cm'),
                            _buildDataItem(Icons.straighten, 'Lingkar Dada', '${e.lingkarDada ?? '-'} cm'),
                            _buildDataItem(Icons.health_and_safety, 'Kondisi Gigi', e.kondisiGigi ?? '-'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRawatInapTab(KesehatanData? data) {
    if (data == null || data.rawatInap.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data rawat inap',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat rawat inap akan muncul di sini',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.rawatInap.length,
      itemBuilder: (context, index) {
        final e = data.rawatInap[index];
        bool isCardExpanded = index == 0 && data.rawatInap.length > 1;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCardExpanded = !isCardExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.teal.shade800,
                                  Colors.teal.shade700,
                                  const Color.fromARGB(255, 53, 187, 171),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_hospital,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e.keluhan,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (data.rawatInap.length > 1)
                              Icon(
                                isCardExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isCardExpanded || data.rawatInap.length == 1)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataItem(Icons.calendar_today, 'Masuk', e.tanggalMasuk ?? '-'),
                            _buildDataItem(Icons.calendar_today_outlined, 'Keluhan', e.keluhan ?? "-"),
                            _buildDataItem(Icons.calendar_today_outlined, 'Terapi', e.terapi ?? "-"),
                            _buildDataItem(Icons.calendar_today_outlined, 'Keluar', e.tanggalKeluar ?? "-"),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDataItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    '$label',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    value.isNotEmpty ? value : "-",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
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