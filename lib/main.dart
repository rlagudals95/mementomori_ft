import 'package:flutter/material.dart';

// --------------------------------------
// [Import Flutter Webview]
import 'package:webview_flutter/webview_flutter.dart';
// --------------------------------------
// [Import for Android features]
import 'package:webview_flutter_android/webview_flutter_android.dart';
// --------------------------------------
// [Import for iOS features]
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// --------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<MyApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setBackgroundColor(Colors.black)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://www.google.co.kr'),
      )
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          return NavigationDecision.navigate;
        },
        onUrlChange: (UrlChange change) {
          debugPrint('url change to ${change.url}');
        },
        onPageFinished: (String url) {
          debugPrint('page finished loading: $url');
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: controller),
    );
  }
}
