import 'package:flutter/material.dart';
import '../../models/keluhan_model.dart';
import '../../services/keluhan_service.dart';
import 'tambah_keluhan_screen.dart';

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

  Widget _buildList(List<KeluhanItem> keluhanList) {
    if (keluhanList.isEmpty) {
      return const Center(child: Text("Tidak ada data."));
    }

    return ListView.builder(
      itemCount: keluhanList.length,
      itemBuilder: (context, index) {
        final item = keluhanList[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(item.kategori, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jenis: ${item.jenis}"),
                Text("Masukan: ${item.masukan}"),
                Text("Saran: ${item.saran}"),
                Text("Rating: ${item.rating}"),
                if (item.status == 'Ditangani' && item.balasan != null)
                  Text("Balasan: ${item.balasan}", style: const TextStyle(color: Colors.green)),
              ],
            ),
            trailing: Text(item.status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: item.status == 'Ditangani' ? Colors.green : Colors.red,
                )),
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
        elevation: 1,
        toolbarHeight: 48,
        automaticallyImplyLeading: true,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Daftar Keluhan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Belum Ditangani'),
            Tab(text: 'Sudah Ditangani'),
          ],
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(belumDitangani),
                    _buildList(ditangani),
                  ],
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
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
            child: Card(
              color: Colors.indigo,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Sumbang Saran",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
