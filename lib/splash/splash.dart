import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../accessdata/alldataisasscess.dart';
import '../home/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Hackapp hack = Provider.of<Hackapp>(context, listen: false);
    Timer(const Duration(seconds: 3), () {
      hack.getDeviceDetails();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green[700],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo here
              Image.asset(
                'assets/logo.png',
                height: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
