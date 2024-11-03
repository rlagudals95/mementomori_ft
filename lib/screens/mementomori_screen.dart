import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class MementoMoriScreen extends StatefulWidget {
  const MementoMoriScreen({Key? key}) : super(key: key);

  @override
  _MementoMoriScreenState createState() => _MementoMoriScreenState();
}

class _MementoMoriScreenState extends State<MementoMoriScreen> {
  final TextEditingController _birthDateController =
      TextEditingController(); // 생일 입력 컨트롤러
  String _gender = 'Male'; // 기본 성별 설정
  int _remainingSeconds = 0; // 남은 수명 초
  Timer? _timer; // 타이머 객체
  bool _isCountdownActive = false; // 카운트다운 활성화 여부

  @override
  void initState() {
    super.initState();

    print('_isCountdownActive');
    print(_isCountdownActive);
    _loadData(); // 저장된 데이터 불러오기
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

      print('birthDateString');
      print(birthDateString);
      if (birthDateString != null) {
        _birthDateController.text = birthDateString;
        _gender = prefs.getString('gender') ?? 'Male';
        _remainingSeconds = prefs.getInt('remainingSeconds') ?? 0;
        _isCountdownActive = prefs.getBool('isCountdownActive') ?? false;

        if (_isCountdownActive) {
          _startCountdown(); // 카운트다운이 활성화된 경우 시작
        }
      }
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  // 데이터 저장하기
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('birthDate', _birthDateController.text);
    await prefs.setString('gender', _gender);
    await prefs.setInt('remainingSeconds', _remainingSeconds);
    await prefs.setBool('isCountdownActive', _isCountdownActive);
  }

  // 카운트다운 시작
  void _startCountdown() {
    if (_timer != null) return; // 이미 타이머가 실행 중이면 중복 실행 방지

    if (!_isCountdownActive) {
      _calculateRemainingSeconds(); // 남은 시간 계산
      _isCountdownActive = true;
      _saveData(); // 데이터 저장
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--; // 매 초마다 남은 시간 감소
          _saveData(); // 데이터 저장
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
      _remainingSeconds = 0;
      _birthDateController.clear();
      _gender = 'Male';
      _isCountdownActive = false;
    });
    _clearData(); // 저장된 데이터 제거
  }

  // 저장된 데이터 제거
  Future<void> _clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('birthDate');
    await prefs.remove('gender');
    await prefs.remove('remainingSeconds');
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
  void _calculateRemainingSeconds() {
    DateTime birthDate = DateTime.parse(_birthDateController.text);
    int lifeExpectancy = _gender == 'Male' ? 79 : 83; // 성별에 따른 평균 수명
    DateTime deathDate = DateTime(
        birthDate.year + lifeExpectancy, birthDate.month, birthDate.day);
    _remainingSeconds = deathDate.difference(DateTime.now()).inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isCountdownActive
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remaining Life: $_remainingSeconds seconds',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _reset,
                    child: Text('Reset'),
                  ),
                ],
              )
            : Column(
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
              ),
      ),
    );
  }
}
