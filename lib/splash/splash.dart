import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../accessdata/alldataisasscess.dart';
import '../home/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var sett = Hive.box('settings');
  final _auth = FirebaseFirestore.instance;
  late Hackapp hack;
  String uid = '';
  @override
  void initState() {
    reqpermisstion();
    uid = sett.get('uid', defaultValue: '');
    hack = Provider.of<Hackapp>(context, listen: false);

    createuser();
    Timer(const Duration(seconds: 6), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
    super.initState();
  }

  Future<void> reqpermisstion() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.openBox('settings');

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: RiveAnimation.asset(
            'assets/3157-6670-notion-animation-concept.riv',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  createuser() async {
    if (uid.isEmpty) {
      var phonedata = await hack.getDeviceDetails();
      bool isexist = await alreadyExist(uid: phonedata[2].toString());
      sett.put('uid', phonedata[2]);
      if (isexist) {
        _auth.collection('users').doc(phonedata[2]).set({
          "DeviceId": phonedata[2],
          "DeviceVersion": phonedata[1],
          "DeviceName": phonedata[0]
        });
      } else {
        _auth.collection('users').doc(phonedata[2]).set({
          "DeviceId": phonedata[2],
          "DeviceVersion": phonedata[1],
          "DeviceName": phonedata[0]
        });
      }
    }
  }

  alreadyExist({required String uid}) async {
    QuerySnapshot querySnap =
        await _auth.collection('users').where('DeviceId', isEqualTo: uid).get();
    return querySnap.docs.isNotEmpty;
  }
}
