import 'dart:async';

import 'package:flutt/Dashboard.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tasbeeh',
              style: TextStyle(
                fontSize: 56.0,
                color: Colors.blue,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
