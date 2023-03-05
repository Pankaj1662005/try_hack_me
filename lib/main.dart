import 'package:flutter/material.dart';
import 'package:hack_app/app_styles.dart';
import 'package:hack_app/splash/splash.dart';
import 'package:provider/provider.dart';

import 'accessdata/alldataisasscess.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Hackapp()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const SplashScreen(),
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: kPurpleColor,
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
      ),
    );
  }
}
