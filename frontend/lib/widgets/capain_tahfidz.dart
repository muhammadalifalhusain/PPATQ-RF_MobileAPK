import 'package:flutter/material.dart';
import '../models/capaian_tahfidz_model.dart';

class CapaianCard extends StatefulWidget {
  final String title;
  final CapaianItem data;

  const CapaianCard({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  State<CapaianCard> createState() => _CapaianCardState();
}

class _CapaianCardState extends State<CapaianCard> {
  bool _expanded = false;

  LinearGradient getGradientColor() {
    if (widget.title.toLowerCase().contains('terendah')) {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 143, 65, 72), // Merah muda
          Color(0xFFD32F2F), // Merah tua
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 94, 151, 110), // Hijau muda
          Color(0xFF00C853), // Hijau tua
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan gradasi warna
          Container(
            decoration: BoxDecoration(
              gradient: getGradientColor(),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.title}: ${widget.data.capaian}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${widget.data.jumlah} Santri',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Daftar santri
          if (_expanded && widget.data.santri != null)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data.santri.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final santri = widget.data.santri[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      santri.photo != null && santri.photo!.isNotEmpty
                          ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photo}'
                          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}&background=random&color=fff',
                    ),
                  ),
                  title: Text(santri.nama),
                  subtitle: Text('Kelas: ${santri.kelas} - ${santri.guruTahfidz}'),
                );
              },
            ),
        ],
      ),
    );
  }
}
