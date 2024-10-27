import 'package:flutter/material.dart';
import '../widgets/quote_display.dart'; // 분리된 위젯을 가져옵니다.
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> quotes = [
    "삶이 있는 한 희망은 있다.",
    "산다는 것 그것은 치열한 전투이다.",
    "하루에 3시간을 걸으면 7년 후에 지구를 한 바퀴 돌 수 있다.",
    "언제나 현재에 집중할 수 있다면 행복할 것이다.",
    "진정으로 웃으려면 고통을 참아야 하며, 나아가 고통을 즐길 줄 알아야 해."
  ];

  late String currentQuote;

  @override
  void initState() {
    super.initState();
    _showRandomQuote(); // 초기화 시 랜덤 명언 설정
  }

  void _showRandomQuote() {
    final randomIndex = Random().nextInt(quotes.length);

    setState(() {
      currentQuote = quotes[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('랜덤 명언 앱')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuoteDisplay(quote: currentQuote), // 분리된 위젯을 사용합니다.
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showRandomQuote,
              child: const Text('명언 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
