import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

class webview extends StatefulWidget {
  const webview({super.key});

  @override
  State<webview> createState() => _webviewState();
}

class _webviewState extends State<webview> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: WebBrowser(
            initialUrl: 'https://Google.com',
          ),
        ),
      ),
    );
  }
}
