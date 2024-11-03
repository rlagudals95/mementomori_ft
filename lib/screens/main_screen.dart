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
  List<Map<String, String>> quoteHistory = []; // 명언과 작가의 히스토리를 저장하는 리스트
  int currentIndex = 0; // 현재 명언의 인덱스를 추적
  final PageController _pageController =
      PageController(); // PageView를 제어하는 컨트롤러
  bool isLoading = false; // 명언을 가져오는 동안 로딩 상태를 추적

  @override
  void initState() {
    super.initState();
    _fetchMultipleQuotes(); // 초기화 시 3개의 명언을 가져옴
  }

  // 3개의 명언을 비동기적으로 가져오는 함수
  Future<void> _fetchMultipleQuotes() async {
    if (isLoading) return; // 이미 로딩 중이면 중복 호출 방지
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < 3; i++) {
      await _fetchRandomQuote();
    }

    setState(() {
      isLoading = false;
    });
  }

  // API로부터 랜덤 명언을 가져오는 함수
  Future<void> _fetchRandomQuote() async {
    final response = await http
        .get(Uri.parse('https://korean-advice-open-api.vercel.app/api/advice'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        quoteHistory.add({'quote': data['message'], 'author': data['author']});
      });
    } else {
      setState(() {
        quoteHistory.add({'quote': "명언을 불러오지 못했습니다.", 'author': ""});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: PageView.builder(
        controller: _pageController, // PageView의 현재 페이지를 제어
        scrollDirection: Axis.vertical, // 수직 스크롤을 가능하게 설정
        itemCount: quoteHistory.length, // 페이지 수를 명언 히스토리의 길이로 설정
        onPageChanged: (index) {
          if (index >= quoteHistory.length - 2 && !isLoading) {
            // 마지막에서 두 번째 페이지에 도달하면 추가 명언을 가져옴
            _fetchMultipleQuotes();
          }
        },
        itemBuilder: (context, index) {
          final quote = quoteHistory[index]['quote']!;
          final author = quoteHistory[index]['author']!;
          return _buildQuotePage(quote, author);
        },
      ),
    );
  }

  // 명언과 작가를 표시하는 페이지를 빌드하는 함수
  Widget _buildQuotePage(String quote, String author) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QuoteDisplay(quote: quote), // 명언을 표시하는 위젯
          if (author.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '- $author', // 작가를 표시
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 20), // 명언과 작가 사이의 간격
        ],
      ),
    );
  }
}
