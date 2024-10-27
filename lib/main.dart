import 'package:flutter/material.dart';
import 'package:memento_mori_ft/screens/webview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InAppWebViewScreen(), // 홈 화면을 설정합니다.
    );
  }
}
