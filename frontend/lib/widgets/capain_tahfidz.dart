import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          Color.fromARGB(255, 143, 65, 72),
          Color(0xFFD32F2F),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 94, 151, 110),
          Color(0xFF00C853),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                gradient: getGradientColor(),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '${widget.title}: ${widget.data.capaian}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.data.jumlah} Santri',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data.santri.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final santri = widget.data.santri[index];

                final photoSantri = santri.photo != null && santri.photo!.isNotEmpty
                    ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photo}'
                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(santri.nama)}&background=random&color=fff';

                final photoUstad = santri.photoUstadTahfidz != null &&
                        santri.photoUstadTahfidz!.isNotEmpty
                    ? 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${santri.photoUstadTahfidz}'
                    : null;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(photoSantri),
                    radius: 25,
                  ),
                  title: Text(
                    santri.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Kelas: ${santri.kelas} - ${santri.guruTahfidz}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: photoUstad != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(photoUstad),
                          radius: 18,
                        )
                      : null,
                );
              },
            ),
        ],
      ),
    );
  }
}
