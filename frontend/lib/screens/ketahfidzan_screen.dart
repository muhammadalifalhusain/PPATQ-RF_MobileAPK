import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ketahfidzan_service.dart';
import '../models/ketahfidzan_model.dart';

class KetahfidzanScreen extends StatefulWidget {
  const KetahfidzanScreen({Key? key}) : super(key: key);

  @override
  _KetahfidzanScreenState createState() => _KetahfidzanScreenState();
}

class _KetahfidzanScreenState extends State<KetahfidzanScreen> {
  final KetahfidzanService _service = KetahfidzanService();
  KetahfidzanResponse? _ketahfidzanData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchKetahfidzanData();
  }

  Future<void> _fetchKetahfidzanData() async {
    try {
      final data = await _service.fetchKetahfidzan();
      setState(() {
        _ketahfidzanData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ketahfidzan Santri'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_ketahfidzanData == null) {
      return const Center(child: Text('Tidak ada data ketahfidzan'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSantriInfo(),
            const SizedBox(height: 20),
            _buildKetahfidzanData(),
          ],
        ),
      ),
    );
  }

  Widget _buildSantriInfo() {
    final santri = _ketahfidzanData!.data.detailSantri.first;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Santri',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text('Nama: ${santri.nama}'),
            Text('No. Induk: ${santri.noInduk}'),
          ],
        ),
      ),
    );
  }

  Widget _buildKetahfidzanData() {
    final ketahfidzan = _ketahfidzanData!.data.ketahfidzan;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Ketahfidzan',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        ...ketahfidzan.entries.map((yearEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tahun ${yearEntry.key}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              ...yearEntry.value.entries.map((monthEntry) {
                return ExpansionTile(
                  title: Text(
                    'Bulan ${_getMonthName(monthEntry.key)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: monthEntry.value.map((entry) {
                          return ListTile(
                            title: Text('Tanggal: ${entry.tanggal}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Juz: ${entry.nmJuz}'),
                                Text('Kode: ${entry.kode}'),
                              ],
                            ),
                            dense: true,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }).toList(),
              const Divider(),
            ],
          );
        }).toList(),
      ],
    );
  }

  String _getMonthName(String monthNumber) {
    final months = {
      '01': 'Januari',
      '02': 'Februari',
      '03': 'Maret',
      '04': 'April',
      '05': 'Mei',
      '06': 'Juni',
      '07': 'Juli',
      '08': 'Agustus',
      '09': 'September',
      '10': 'Oktober',
      '11': 'November',
      '12': 'Desember',
    };
    return months[monthNumber] ?? monthNumber;
  }
}