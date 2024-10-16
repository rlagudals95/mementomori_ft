import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue), home: const MyHomepage());
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Scaffold(뼈대)로 레이아웃을 만든다.
        appBar: AppBar(title: const Text('title')),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text("Drawer Header Part"),
            ),
            ListTile(
              title: Text("Menu 1"),
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print('press'),
          child: const Icon(Icons.mouse),
        ),
        body: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 200,
                    color: Colors.blue),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 200,
                    color: Colors.red)
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 200,
                    color: Colors.purple),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 200,
                    color: Colors.yellow)
              ])
            ],
          ),
        ));
  }
}
