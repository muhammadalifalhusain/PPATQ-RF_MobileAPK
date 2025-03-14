import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image.asset('assets/images/logo.png', height: 50),
        Text('PPATQ RAUDLATUL FALAH', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
        Text('Copyright © 2025 All Rights Reserved', style: TextStyle(fontSize: 14, color: Colors.black54)),
        SizedBox(height: 15),
      ],
    );
  }
}
