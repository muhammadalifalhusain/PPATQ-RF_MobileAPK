import 'package:flutter/material.dart';
import '../../models/keluhan_model.dart';
import '../../services/keluhan_service.dart';
import 'tambah_keluhan_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/loading_screen.dart';

import 'package:google_fonts/google_fonts.dart';
class KeluhanListScreen extends StatefulWidget {
  const KeluhanListScreen({Key? key}) : super(key: key);

  @override
  State<KeluhanListScreen> createState() => _KeluhanListScreenState();
}

class _KeluhanListScreenState extends State<KeluhanListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<KeluhanItem> ditangani = [];
  List<KeluhanItem> belumDitangani = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchKeluhan();
  }

  Future<void> _fetchKeluhan() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await KeluhanService().fetchKeluhan();
      setState(() {
        ditangani = response.ditangani;
        belumDitangani = response.belumDitangani;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: Colors.teal.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Belum ada keluhan yang tersedia",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKeluhanCard(KeluhanItem item) {
    final isHandled = item.status == 'Ditangani';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isHandled ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                isHandled ? Colors.green.withOpacity(0.05) : Colors.orange.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.kategori,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
                const SizedBox(height: 6),
                _buildDetailRow(Icons.category, "Jenis", item.jenis),
                const SizedBox(height: 6),
                _buildDetailRow(Icons.feedback, "Masukan", item.masukan),
                const SizedBox(height: 6),
                _buildDetailRow(Icons.lightbulb, "Saran", item.saran),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Rating: ${item.rating}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                  ],
                ),
                if (isHandled && item.balasan != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Balasan:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item.balasan!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // jarak atas-bawah lebih rapat
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6), // padding icon lebih kecil
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 18, // icon sedikit lebih kecil
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 1), // jarak label ke value lebih rapat
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
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


  Widget _buildList(List<KeluhanItem> keluhanList, bool isHandled) {
    if (keluhanList.isEmpty) {
      return _buildEmptyState(
        isHandled ? "Belum ada keluhan yang ditangani" : "Belum ada keluhan masuk",
        isHandled ? Icons.check_circle_outline : Icons.pending_actions,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchKeluhan,
      color: Colors.teal,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: keluhanList.length,
        itemBuilder: (context, index) {
          return _buildKeluhanCard(keluhanList[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        toolbarHeight: 56,
        automaticallyImplyLeading: false, 
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.white), 
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Daftar Keluhan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(child: Text('Belum Ditangani')),
                Tab(child: Text('Sudah Ditangani')),
              ],
            ),
          ),
        ),
      ),

      body: isLoading
          ? const LoadingScreen(
              message: 'Memuat data Daftar Keluhan...',
              backgroundColor: Colors.teal,
              progressColor: Colors.white,
              icon: FontAwesomeIcons.comments,
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Terjadi Kesalahan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _fetchKeluhan,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Coba Lagi"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(belumDitangani, false),
                    _buildList(ditangani, true),
                  ],
                ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade800,
              Colors.teal.shade700,
              const Color.fromARGB(255, 53, 187, 171),
            ],
          ),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TambahKeluhanScreen(
                  keluhanService: KeluhanService(),
                ),
              ),
            ).then((result) {
              if (result == true) {
                _fetchKeluhan();
              }
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
          label: const Text(
            "Sumbang Saran",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}