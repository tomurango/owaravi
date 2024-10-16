import 'package:flutter/material.dart';
import 'recommended_screen.dart';
import 'registered_screen.dart';
import 'mypage_screen.dart';
import 'settings_screen.dart';
import 'video_upload_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RecommendedScreen(),
    RegisteredScreen(),
    MyPageScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owaravi')),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 動画アップロード画面に遷移
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoUploadScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
            BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'おすすめ',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '登録済み',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
            ),
        ],
      ),
    );
  }
}
