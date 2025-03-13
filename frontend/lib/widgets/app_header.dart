import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Center(child: Image.asset('assets/images/logo.png', height: 80)),
          SizedBox(height: 10),
          Text('PPATQ RAUDLATUL FALAH', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
          SizedBox(height: 5),
          Text(
            'Pondok Pesantren Anak-anak Tahfidzul Qur\'an Raudlatul Falah – Pati',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, size: 30, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
