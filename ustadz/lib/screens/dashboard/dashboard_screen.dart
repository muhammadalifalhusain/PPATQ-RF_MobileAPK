import 'package:flutter/material.dart';
import '../../../services/data-santri_service.dart';
import '../../../models/tahfidz-data.dart';

class DashboardScreen extends StatefulWidget {
  final int userId;
  final Map<String, dynamic> murrobyData;

  const DashboardScreen({
    Key? key,
    required this.userId,
    required this.murrobyData,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  List<SantriTahfidz> santriTahfidzList = [];
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static const String fotoGaleriBaseUrl =
      "https://manajemen.ppatq-rf.id/assets/img/upload/photo/";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    fetchTahfidzData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchTahfidzData() async {
    try {
      final response = await TahfidzService.fetchTahfidzData(widget.userId);
      setState(() {
        santriTahfidzList = response.data;
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data tahfidz: ${e.toString()}'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchTahfidzData();
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl =
        widget.murrobyData['photo'] != null && widget.murrobyData['photo'] != ''
            ? fotoGaleriBaseUrl + widget.murrobyData['photo']
            : null;

    final namaMurroby = widget.murrobyData['nama'] ?? 'Nama tidak tersedia';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: Colors.teal,
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(namaMurroby, photoUrl),
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatsCards(),
                            const SizedBox(height: 24),
                            _buildTahfidzSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00695C), Color(0xFF004D40)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat data tahfidz...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(String namaMurroby, String? photoUrl) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.teal[600],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'Dashboard Tahfidz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.teal[400]!,
                Colors.teal[700]!,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'murroby_photo',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                        backgroundColor: Colors.white,
                        child: photoUrl == null
                            ? Icon(Icons.person, size: 40, color: Colors.teal[600])
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    namaMurroby,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    // Hitung statistik tahfidz
    int totalSantri = santriTahfidzList.length;
    int khatamanCount = santriTahfidzList.where((santri) => santri.juz == 'Khataman').length;
    int progressCount = totalSantri - khatamanCount;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Santri',
            value: totalSantri.toString(),
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Khataman',
            value: khatamanCount.toString(),
            icon: Icons.celebration,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Dalam Proses',
            value: progressCount.toString(),
            icon: Icons.book,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTahfidzSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Tahfidz Santri',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        if (santriTahfidzList.isEmpty)
          _buildEmptyState()
        else
          _buildTahfidzList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada data tahfidz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Data progress tahfidz akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTahfidzList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: santriTahfidzList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final santri = santriTahfidzList[index];
        return _buildTahfidzCard(santri, index);
      },
    );
  }

  Widget _buildTahfidzCard(SantriTahfidz santri, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getJuzColor(santri.juz).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  santri.juz == 'Khataman' ? Icons.celebration : Icons.book,
                  color: _getJuzColor(santri.juz),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    santri.namaSantri,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bulan: ${santri.bulan}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getJuzColor(santri.juz).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                santri.juz,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getJuzColor(santri.juz),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getJuzColor(String juz) {
    if (juz == 'Khataman') {
      return Colors.green;
    } else if (juz.contains('Akhir')) {
      return Colors.orange;
    } else {
      return Colors.teal;
    }
  }
}