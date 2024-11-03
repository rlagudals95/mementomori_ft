import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/quote_display.dart'; // 분리된 위젯을 가져옵니다.

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentQuote = "명언을 불러오는 중...";
  String author = "";

  @override
  void initState() {
    super.initState();
    _fetchRandomQuote(); // 초기화 시 랜덤 명언 설정
  }

  Future<void> _fetchRandomQuote() async {
    final response = await http
        .get(Uri.parse('https://korean-advice-open-api.vercel.app/api/advice'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        currentQuote = data['message'];
        author = data['author'];
      });
    } else {
      setState(() {
        currentQuote = "명언을 불러오지 못했습니다.";
        author = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuoteDisplay(quote: currentQuote), // 분리된 위젯을 사용합니다.
            if (author.isNotEmpty) // 작가 이름이 있을 경우에만 표시
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '- $author',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchRandomQuote,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12), // Custom style: rounded corners
                ),
              ),
              child: const Text('랜덤 명언 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
