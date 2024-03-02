import 'package:flutter/material.dart';

import 'about_us_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Version 1.0.0'),
            onTap: () {
              // Handle Version 1.0.0 action
            },
          ),
          ListTile(
            title: Text('Rate Us'),
            onTap: () {
              // Handle Rate Us action
            },
          ),
          ListTile(
            title: Text('Developer'),
            onTap: () {
              // Handle Developer action
            },
          ),
          ListTile(
            title: Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
