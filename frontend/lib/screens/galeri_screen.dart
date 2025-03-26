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
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.34),

                  _buildTitleSection(),

                  if (_errorMessage.isNotEmpty) _buildErrorSection(),

                  FutureBuilder<List<Galeri>>(
                    future: _galeriFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError || _errorMessage.isNotEmpty) {
                        return SizedBox(); // Error sudah ditampilkan di atas
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyDataSection();
                      }
                      return _buildGaleriGrid(snapshot.data!);
                    },
                  ),

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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'GALERI PPATQ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          Text(
            'Kumpulan Moment Berharga PPATQ RADLATUL FALAH',
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildErrorSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(_errorMessage, style: TextStyle(color: Colors.red)),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadGaleri,
            child: Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDataSection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Tidak ada data galeri tersedia', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildGaleriGrid(List<Galeri> galeriList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: galeriList.length,
      itemBuilder: (context, index) {
        return _buildGaleriItem(galeriList[index]);
      },
    );
  }

  Widget _buildGaleriItem(Galeri galeri) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showImageDialog(context, galeri),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  galeri.foto,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    galeri.nama,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    galeri.deskripsi,
                    style: TextStyle(fontSize: 12),
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withOpacity(0.7),
            child: AppHeader(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(galeri.nama, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Image.network(galeri.foto),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(galeri.deskripsi),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}
