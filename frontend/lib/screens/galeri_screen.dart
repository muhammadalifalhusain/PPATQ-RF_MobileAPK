import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/galeri_model.dart';
import '../../services/galeri_service.dart';

class GaleriScreen extends StatefulWidget {
  const GaleriScreen({Key? key}) : super(key: key);

  @override
  State<GaleriScreen> createState() => _GaleriScreenState();
}

class _GaleriScreenState extends State<GaleriScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<GaleriItem> _galeriList = [];
  List<GaleriItem> _fasilitasList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final galeri = await GaleriService.fetchGaleri();
      final fasilitas = await GaleriService.fetchFasilitas();
      setState(() {
        _galeriList = galeri;
        _fasilitasList = fasilitas;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  String getImageUrl(GaleriItem item, bool isFasilitas) {
    final baseUrl = isFasilitas
        ? 'https://manajemen.ppatq-rf.id/assets/img/upload/foto_fasilitas/'
        : 'https://manajemen.ppatq-rf.id/assets/img/upload/foto_galeri/';
    return '$baseUrl${item.foto}';
  }

  void _showImageFull(GaleriItem item, bool isFasilitas) {
    final imageUrl = getImageUrl(item, isFasilitas);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Hero(
                tag: 'img_${item.foto}',
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 80),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List<GaleriItem> items, bool isFasilitas) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final imageUrl = getImageUrl(item, isFasilitas);
        return GestureDetector(
          onTap: () => _showImageFull(item, isFasilitas),
          child: Hero(
            tag: 'img_${item.foto}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  ),
                  if (item.nama.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        color: Colors.black54,
                        child: Text(
                          item.nama,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        toolbarHeight: 56,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Galeri',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.teal.shade50,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              tabs: const [
                Tab(text: 'Galeri'),
                Tab(text: 'Fasilitas'),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGrid(_galeriList, false),
                      _buildGrid(_fasilitasList, true),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
