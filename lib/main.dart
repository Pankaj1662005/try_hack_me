import 'package:flutter/material.dart';
import 'package:hack_app/splash/splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'accessdata/alldataisasscess.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('settings');
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
    return const MaterialApp(
      title: 'showimage',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
