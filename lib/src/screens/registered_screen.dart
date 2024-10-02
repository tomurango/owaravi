import 'package:flutter/material.dart';

// 登録済み画面のサンプル
class RegisteredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登録済み'),
      ),
      body: Center(
        child: Text('登録済み画面', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}