import 'package:flutter/material.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../models/agenda_model.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<Agenda> agendaList = [];
  int currentPage = 1;
  final int perPage = 5;
  bool isLoading = false;
  bool hasMoreData = true;
  bool isInitialLoad = true;
  Timer? _debounceTimer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialData();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await fetchAgendaData();
    setState(() => isInitialLoad = false);
  }

  Future<void> fetchAgendaData() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final newAgenda = await ApiService().fetchAgenda(
        perPage: perPage,
        page: currentPage,
      );

      setState(() {
        agendaList = newAgenda;
        hasMoreData = newAgenda.length >= perPage;
      });
    } catch (e) {
      _showErrorSnackbar("Gagal memuat data agenda");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _scrollListener() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (hasMoreData && !isLoading) {
          _nextPage();
        }
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _nextPage() {
    if (!hasMoreData) return;
    setState(() => currentPage++);
    _scrollToTop();
    fetchAgendaData();
  }

  void _previousPage() {
    if (currentPage <= 1) return;
    setState(() => currentPage--);
    _scrollToTop();
    fetchAgendaData();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildInitialLoader() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Memuat agenda..."),
        ],
      ),
    );
  }

  Widget _buildAgendaList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: agendaList.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= agendaList.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final agenda = agendaList[index];
        return _buildAgendaCard(agenda);
      },
    );
  }

  Widget _buildAgendaCard(Agenda agenda) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agenda.judul,
              style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 18, color: Colors.teal),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Mulai: ${agenda.tanggalMulai}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.event_available, size: 18, color: Colors.teal),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Selesai: ${agenda.tanggalSelesai}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: currentPage > 1 ? _previousPage : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text("Prev"),
          ),
          const SizedBox(width: 16),
          Text(
            "Page $currentPage",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: hasMoreData ? _nextPage : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Next"),
          ),
        ],
      ),
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
          'Agenda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isInitialLoad
                  ? _buildInitialLoader()
                  : _buildAgendaList(),
            ),
            _buildPagination(),
          ],
        ),
      ),
    );
  }
}
