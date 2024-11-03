import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class MementomoriScreen extends StatefulWidget {
  const MementomoriScreen({Key? key}) : super(key: key);

  @override
  _MementomoriScreenState createState() => _MementomoriScreenState();
}

class _MementomoriScreenState extends State<MementomoriScreen> {
  final TextEditingController _birthDateController =
      TextEditingController(); // 생일 입력 컨트롤러
  String _gender = 'Male'; // 기본 성별 설정
  DateTime? _targetDate;
  Timer? _timer; // 타이머 객체
  bool _isCountdownActive = false; // 카운트다운 활성화 여부
  bool _isLoading = true; // 로딩 상태를 관리하는 변수

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 취소
    _birthDateController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  // 저장된 데이터 불러오기
  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? birthDateString = prefs.getString('birthDate');
      String? targetDateString = prefs.getString('targetDate');

      if (birthDateString != null && targetDateString != null) {
        _birthDateController.text = birthDateString;
        _gender = prefs.getString('gender') ?? 'Male';
        _targetDate = DateTime.parse(targetDateString);
        _isCountdownActive = prefs.getBool('isCountdownActive') ?? false;

        if (_isCountdownActive) {
          _startCountdown(); // 카운트다운이 활성화된 경우 시작
        }
      }
    } catch (e) {
      print('Failed to load data: $e');
    } finally {
      setState(() {
        _isLoading = false; // 데이터 로드가 완료되면 로딩 상태를 false로 설정
      });
    }
  }

  // 데이터 저장하기
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('birthDate', _birthDateController.text);
    await prefs.setString('gender', _gender);
    if (_targetDate != null) {
      await prefs.setString('targetDate', _targetDate!.toIso8601String());
    }
    await prefs.setBool('isCountdownActive', _isCountdownActive);
  }

  // 카운트다운 시작
  void _startCountdown() {
    if (_timer != null) {
      _timer!.cancel(); // 이미 타이머가 실행 중이면 타이머 해제
    }

    if (!_isCountdownActive) {
      _calculateTargetDate();
      _isCountdownActive = true;
      _saveData(); // 데이터 저장
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_targetDate != null && DateTime.now().isBefore(_targetDate!)) {
          _saveData();
        } else if (DateTime.now().isAfter(_targetDate!)) {
          // 남은 수명이 없는 경우 처리
          _isCountdownActive = false;
          _timer?.cancel();
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Text(
                    '남은 수명이 없습니다.',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              );
            },
          );
        } else {
          timer.cancel(); // 시간이 다 되면 타이머 취소
        }
      });
    });
  }

  // 초기화
  void _reset() {
    _timer?.cancel();
    setState(() {
      _birthDateController.clear();
      _gender = 'Male';
      _isCountdownActive = false;
      _targetDate = null;
    });
    _clearData(); // 저장된 데이터 제거
  }

  // 저장된 데이터 제거
  Future<void> _clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('birthDate');
    await prefs.remove('gender');
    await prefs.remove('targetDate');
    await prefs.remove('isCountdownActive');
  }

  // 날짜 선택
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  // 남은 시간 계산
  void _calculateTargetDate() {
    DateTime birthDate = DateTime.parse(_birthDateController.text);
    int lifeExpectancy = _gender == 'Male' ? 79 : 83; // 성별에 따른 평균 수명
    _targetDate = DateTime(
        birthDate.year + lifeExpectancy, birthDate.month, birthDate.day);
  }

  int _calculateRemainingSeconds() {
    if (_targetDate == null) return 0;
    return _targetDate!.difference(DateTime.now()).inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator()) // 로딩 중일 때 로딩 인디케이터 표시
              : _isCountdownActive
                  ? _buildCountdownView()
                  : _buildInputView(),
        ),
      ),
    );
  }

  Widget _buildCountdownView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '남은 수명',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        TweenAnimationBuilder<int>(
          tween: IntTween(
              begin: _calculateRemainingSeconds(),
              end: _calculateRemainingSeconds()),
          duration: Duration(seconds: 1),
          builder: (context, value, child) {
            return Text(
              '$value',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          },
          onEnd: () {
            setState(() {});
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _reset,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 배경색을 흰색으로 설정
          ),
          child: Icon(Icons.restart_alt),
        ),
      ],
    );
  }

  Widget _buildInputView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _birthDateController,
          decoration: InputDecoration(
            labelText: 'Enter your birth date (YYYY-MM-DD)',
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          readOnly: true,
        ),
        DropdownButton<String>(
          value: _gender,
          onChanged: (String? newValue) {
            setState(() {
              _gender = newValue!;
            });
          },
          items: <String>['Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _startCountdown,
          child: Text('Start Countdown'),
        ),
      ],
    );
  }
}
