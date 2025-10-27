import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class TanggalPembayaranDropdown extends StatefulWidget {
  final Function(String) onDateChanged;

  const TanggalPembayaranDropdown({super.key, required this.onDateChanged});

  @override
  _TanggalPembayaranDropdownState createState() =>
      _TanggalPembayaranDropdownState();
}

class _TanggalPembayaranDropdownState
    extends State<TanggalPembayaranDropdown> {
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDay = now.day;
    selectedMonth = now.month;
    selectedYear = now.year;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDate();
    });
  }

  void _updateDate() {
    if (selectedDay != null && selectedMonth != null && selectedYear != null) {
      final date = DateTime(selectedYear!, selectedMonth!, selectedDay!);
      final formatted = DateFormat('yyyy-MM-dd').format(date);
      widget.onDateChanged(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<int> days = List.generate(31, (i) => i + 1);
    final List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final List<int> years = List.generate(11, (i) => 2020 + i);

    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.teal.shade300),
    );

    InputDecoration buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
        border: borderStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        filled: true,
        fillColor: Colors.transparent, 
      );
    }

    TextStyle itemStyle = GoogleFonts.poppins(fontSize: 14, color: Colors.black);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal Pembayaran',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: selectedDay,
                    style: itemStyle,
                    dropdownColor: Colors.white,
                    items: days.map((d) {
                      return DropdownMenuItem(
                        value: d,
                        child: Text(d.toString(), style: itemStyle),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedDay = val;
                        _updateDate();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6),

                // Dropdown Bulan
                Flexible(
                  flex: 4,
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: selectedMonth,
                    style: itemStyle,
                    dropdownColor: Colors.white,
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(months[index], style: itemStyle),
                      );
                    }),
                    onChanged: (val) {
                      setState(() {
                        selectedMonth = val;
                        _updateDate();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: selectedYear,
                    style: itemStyle,
                    dropdownColor: Colors.white,
                    items: years.map((y) {
                      return DropdownMenuItem(
                        value: y,
                        child: Text(y.toString(), style: itemStyle),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedYear = val;
                        _updateDate();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
