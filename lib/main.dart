// 1. Import packages
import 'package:flutter/material.dart';

// 2. Import screens
import 'screens/left_notice.dart';
import 'screens/right_notice.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSE Notices',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 두 개의 탭
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notice Board'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'SW Univ Notices'),
              Tab(text: 'CSE Notices'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeftNoticePage(), // 왼쪽 탭
            RightNoticePage(), // 오른쪽 탭
          ],
        ),
      ),
    );
  }
}