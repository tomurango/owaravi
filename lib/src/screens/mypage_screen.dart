import 'package:flutter/material.dart';

// マイページ画面のサンプル
class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
      ),
      body: Center(
        child: Text('マイページ画面', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}