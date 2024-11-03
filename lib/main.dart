import 'package:flutter/material.dart';
import 'package:memento_mori_ft/screens/main_screen.dart';
import 'package:memento_mori_ft/screens/mementomori_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MainScreen(),
    MementomoriScreen(),
    // Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // if (index == 1) {
    //   // 예: 바텀 시트 표시
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container(
    //         height: 200,
    //         color: Colors.white,
    //       );
    //     },
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: '',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: '',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures icons are evenly spaced
        showSelectedLabels: false, // Hides the selected labels
        showUnselectedLabels: false, // Hides the unselected labels
      ),
    );
  }
}
