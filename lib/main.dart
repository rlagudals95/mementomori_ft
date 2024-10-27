import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // 홈 화면을 가져옵니다.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(), // 홈 화면을 설정합니다.
    );
  }
}
