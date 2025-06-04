import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/api_service.dart';
import '../models/galeri_model.dart';
import '../widgets/app_header.dart';
import '../widgets/footer_widget.dart';

class GaleriScreen extends StatefulWidget {
  const GaleriScreen({Key? key}) : super(key: key);

  @override
  State<GaleriScreen> createState() => _GaleriScreenState();
}

class _GaleriScreenState extends State<GaleriScreen> {
  late Future<List<Galeri>> _galeriFuture;
  final ApiService _apiService = ApiService();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadGaleri();
  }

  void _loadGaleri() {
    setState(() {
      _errorMessage = '';
      _galeriFuture = _apiService.fetchGaleri().catchError((error) {
        setState(() {
          _errorMessage = "Terjadi kesalahan: ${error.toString()}";
        });
        return <Galeri>[];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.32),
                  _buildTitleSection(),
                  if (_errorMessage.isNotEmpty) _buildErrorSection(),
                  FutureBuilder<List<Galeri>>(
                    future: _galeriFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError || _errorMessage.isNotEmpty) {
                        return SizedBox();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyDataSection();
                      }
                      return _buildGaleriGrid(snapshot.data!);
                    },
                  ),
                  const SizedBox(height: 32),
                  FooterWidget(),
                ],
              ),
            ),
            _buildHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Galeri PPATQ',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Kumpulan Moment Berharga PPATQ Raudlatul Falah',
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildErrorSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(_errorMessage, style: TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadGaleri,
            child: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDataSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text(
        'Tidak ada data galeri tersedia',
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }

  Widget _buildGaleriGrid(List<Galeri> galeriList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: galeriList.length,
        itemBuilder: (context, index) => _buildGaleriItem(galeriList[index]),
      ),
    );
  }

  Widget _buildGaleriItem(Galeri galeri) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, galeri),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                galeri.foto,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 48),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes!)
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    galeri.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    galeri.deskripsi,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const AppHeader(
              showAuthButtons: true,
              showBackButton: true,
            ),
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, Galeri galeri) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(galeri.foto, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      galeri.nama,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      galeri.deskripsi,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
