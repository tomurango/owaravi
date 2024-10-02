import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 設定画面のサンプル
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('設定画面', style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}