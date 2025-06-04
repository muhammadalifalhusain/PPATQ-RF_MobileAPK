import 'package:flutter/material.dart';
import '../models/pegawai_model.dart';
import '../services/pegawai_service.dart';

class PegawaiDataScreen extends StatefulWidget {
  const PegawaiDataScreen({Key? key}) : super(key: key);

  @override
  State<PegawaiDataScreen> createState() => _PegawaiDataScreenState();
}

class _PegawaiDataScreenState extends State<PegawaiDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PegawaiService _service = PegawaiService();

  late Future<List<Pegawai>> _ustadzFuture;
  late Future<List<Pegawai>> _murrobyFuture;
  late Future<List<Pegawai>> _staffFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _ustadzFuture = _service.fetchUstadz();
    _murrobyFuture = _service.fetchMurroby();
    _staffFuture = _service.fetchStaff();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildList(List<Pegawai> list) {
    if (list.isEmpty) {
      return const Center(child: Text('Data kosong'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final pegawai = list[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(pegawai.photoUrl),
            backgroundColor: Colors.grey[200],
          ),
          title: Text(pegawai.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${pegawai.jabatan} • ${pegawai.jenisKelamin}'),
          trailing: pegawai.alhafidz
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Alhafidz', style: TextStyle(color: Colors.green)),
                )
              : null,
        );
      },
    );
  }

  Widget _buildTab(Future<List<Pegawai>> future) {
    return FutureBuilder<List<Pegawai>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return _buildList(snapshot.data ?? []);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pegawai'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ustadz'),
            Tab(text: 'Murroby'),
            Tab(text: 'Staff'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTab(_ustadzFuture),
          _buildTab(_murrobyFuture),
          _buildTab(_staffFuture),
        ],
      ),
    );
  }
}
