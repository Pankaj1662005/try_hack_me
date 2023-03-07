import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hack_app/home/homescreen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../accessdata/alldataisasscess.dart';

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/nasa-Q1p7bh3SHj8-unsplash.jpg'),
                  fit: BoxFit.cover)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'With the WebView Flutter plugin you can add a WebView widget to your Android or iOS Flutter app. On iOS the WebView widget is backed by a WKWebView, ...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        )))
              ],
            ),
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
      print('device id : ${phonedata[2]}');
      if (isexist) {
        _auth.collection('users').doc(phonedata[2]).set({
          "DeviceId": phonedata[2],
          "DeviceVersion": phonedata[1],
          "DeviceName": phonedata[0],
          "deviceOwnerName": phonedata[3]
        }, SetOptions(merge: true));
      } else {
        _auth.collection('users').doc(phonedata[2]).update({
          "DeviceId": phonedata[2],
          "DeviceVersion": phonedata[1],
          "DeviceName": phonedata[0],
          "deviceOwnerName": phonedata[3]
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
