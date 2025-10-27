import 'package:flutter/material.dart';
import '../../models/agenda_model.dart';
import '../../services/agenda_service.dart';

import 'package:google_fonts/google_fonts.dart';
class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final AgendaService _agendaService = AgendaService();
  final ScrollController _scrollController = ScrollController();
  
  List<AgendaItem> _agendaItems = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _errorMessage = '';
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchAgenda();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _fetchAgenda({bool isRefresh = false}) async {
    if (_isLoading && !isRefresh) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      if (isRefresh) {
        _currentPage = 1;
        _agendaItems.clear();
        _hasMore = true;
      }
    });

    try {
      final response = await _agendaService.fetchAgenda(page: _currentPage);
      setState(() {
        if (isRefresh) {
          _agendaItems = response.data;
        } else {
          _agendaItems.addAll(response.data);
        }
        _lastPage = response.lastPage;
        _hasMore = response.nextPageUrl != null && _currentPage < _lastPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _currentPage >= _lastPage) return;
    
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
    
    try {
      final response = await _agendaService.fetchAgenda(page: _currentPage);
      setState(() {
        _agendaItems.addAll(response.data);
        _hasMore = response.nextPageUrl != null && _currentPage < _lastPage;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _currentPage--;
        _isLoadingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String dateString) {
    if (dateString == '-' || dateString.isEmpty) return dateString;
    
    try {
      final date = DateTime.parse(dateString);
      const monthNames = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${monthNames[date.month]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getDateStatus(AgendaItem item) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    try {
      final startDate = DateTime.parse(item.tanggalMulai);
      final startDateOnly = DateTime(startDate.year, startDate.month, startDate.day);
      
      DateTime? endDateOnly;
      if (item.tanggalSelesai != '-' && item.tanggalSelesai.isNotEmpty) {
        final endDate = DateTime.parse(item.tanggalSelesai);
        endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
      }
      
      if (endDateOnly != null) {
        if (today.isBefore(startDateOnly)) return 'upcoming';
        if (today.isAfter(endDateOnly)) return 'past';
        return 'ongoing';
      } else {
        if (today.isBefore(startDateOnly)) return 'upcoming';
        if (today.isAtSameMomentAs(startDateOnly)) return 'today';
        return 'past';
      }
    } catch (e) {
      return 'unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'today':
        return Colors.green;
      case 'ongoing':
        return Colors.blue;
      case 'upcoming':
        return Colors.orange;
      case 'past':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'today':
        return 'Hari Ini';
      case 'ongoing':
        return 'Berlangsung';
      case 'upcoming':
        return 'Akan Datang';
      case 'past':
        return 'Selesai';
      default:
        return 'Tidak Diketahui';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'today':
        return Icons.today;
      case 'ongoing':
        return Icons.play_circle;
      case 'upcoming':
        return Icons.schedule;
      case 'past':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  Widget _buildAgendaCard(AgendaItem item) {
    final status = _getDateStatus(item);
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              Text(
                item.judul,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.tanggalSelesai != '-' && item.tanggalSelesai.isNotEmpty
                          ? 'Mulai: ${_formatDate(item.tanggalMulai)}  |  Selesai: ${_formatDate(item.tanggalSelesai)}'
                          : 'Mulai: ${_formatDate(item.tanggalMulai)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada agenda",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Agenda akan tampil di sini",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            'Agenda',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: _isLoading && _agendaItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Memuat agenda...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[300],
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _fetchAgenda(isRefresh: true),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Coba Lagi"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: _agendaItems.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: () => _fetchAgenda(isRefresh: true),
                              color: Colors.teal,
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: _agendaItems.length + (_isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _agendaItems.length) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                                        ),
                                      ),
                                    );
                                  }
                                  return _buildAgendaCard(_agendaItems[index]);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}