import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VirtualTryOnWebView extends StatelessWidget {
  final String url;

  const VirtualTryOnWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Try-On'),
      ),
      body: const WebView(
        initialUrl: 'http://192.168.68.137:5000/',
      ),
    );
  }
}
