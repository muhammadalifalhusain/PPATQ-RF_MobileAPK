import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Register'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
          ),
        ],
      ),
    );
  }
}
