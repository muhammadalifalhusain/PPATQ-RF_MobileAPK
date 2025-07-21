import 'package:flutter/material.dart';
import 'package:frontend/screens/informasi_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/about_screen.dart';
import '../screens/agenda_screen.dart';
import '../screens/galeri_screen.dart';
import '../screens/pegawai_screen.dart';
import '../screens/dakwah_screen.dart';
import '../screens/surah_list_screen.dart';

class MenuIkonWidget extends StatefulWidget {
  @override
  _MenuIkonWidgetState createState() => _MenuIkonWidgetState();
}

class _MenuIkonWidgetState extends State<MenuIkonWidget> with TickerProviderStateMixin {
  bool _showAllMenus = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Convert _menus to a getter to allow instance method access
  List<Map<String, dynamic>> get _menus => [
    {
      'icon': Icons.info,
      'label': 'PPATQ-RF ku',
      'color': Colors.blue,
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen())),
    },
    {
      'icon': Icons.people,
      'label': 'Staff',
      'color': Colors.teal,
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => PegawaiDataScreen())),
    },
    {
      'icon': Icons.record_voice_over,
      'label': 'Dawuh Abah',
      'color': Colors.green,
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => DakwahScreen())),
    },
    {
      'icon': Icons.feedback,
      'label': 'Informasi',
      'color': Colors.red,
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => InformasiScreen())),
    },
    {
      'icon': Icons.book,
      'label': 'AL-Quran',
      'color': Colors.indigo,
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => QuranScreen())),
    },
    {
      'icon': Icons.location_on,
      'label': 'Lokasi',
      'color': Colors.amber,
      'action': (BuildContext context) => _launchWithFallback(
        "geo:0,0?q=PPATQ+Raudlatul+Falah", 
        "https://maps.app.goo.gl/WJxpAMFN8htranSa8", 
      ),
    },
    {
      'icon': Icons.calendar_today,
      'label': 'Agenda',
      'color': Colors.orange,
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => AgendaScreen())),
    },
    {
      'icon': Icons.photo_library,
      'label': 'Galeri',
      'color': Colors.purple,
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => GaleriScreen())),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMainMenuGrid(),
          if (!_showAllMenus) ...[
            SizedBox(height: 8),
            _buildMoreButton(),
          ],
          if (_showAllMenus) ...[
            SizedBox(height: 8),
            _buildAdditionalMenuGrid(),
            SizedBox(height: 8),
            _buildLessButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildMainMenuGrid() {
    final mainMenus = _menus.take(6).toList();

    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.1,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: mainMenus.map((menu) => _buildMenuIkon(
        menu['icon'],
        menu['label'],
        menu['color'],
        () => menu['action'](context),
      )).toList(),
    );
  }

  Widget _buildAdditionalMenuGrid() {
    final additionalMenus = _menus.skip(6).toList();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: additionalMenus.map((menu) => _buildMenuIkon(
          menu['icon'],
          menu['label'],
          menu['color'],
          () => menu['action'](context),
        )).toList(),
      ),
    );
  }

  Widget _buildMenuIkon(IconData ikon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                ikon, 
                size: 28, 
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return GestureDetector(
      onTap: () {
        setState(() => _showAllMenus = true);
        _animationController.forward();
      },
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 30,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildLessButton() {
    return GestureDetector(
      onTap: () {
        _animationController.reverse().then((_) {
          setState(() => _showAllMenus = false);
        });
      },
      child: Icon(
        Icons.keyboard_arrow_up_rounded,
        size: 30,
        color: Colors.grey[600],
      ),
    );
  }

  Future<void> _launchWithFallback(String uri, String fallbackUrl) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      await launch(fallbackUrl);
    }
  }
}
