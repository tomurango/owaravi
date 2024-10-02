import 'package:flutter/material.dart';

// おすすめ画面のサンプル
class RecommendedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('おすすめ'),
      ),
      body: Center(
        child: Text('おすすめ画面', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

