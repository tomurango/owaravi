import 'package:flutter/material.dart';
import 'video_show_screen.dart';

// おすすめ画面のサンプル
class RegisteredScreen extends StatelessWidget {
  // ダミーデータのリスト
  final List<Map<String, String>> videos = [
    {
      'thumbnail': 'https://via.placeholder.com/150',
      'title': 'Flutter Tutorial',
      'uploader': 'Flutter Dev',
      'uploaderIcon': 'https://via.placeholder.com/50',
    },
    {
      'thumbnail': 'https://via.placeholder.com/150',
      'title': 'Firebase Introduction',
      'uploader': 'Firebase Team',
      'uploaderIcon': 'https://via.placeholder.com/50',
    },
    {
      'thumbnail': 'https://via.placeholder.com/150',
      'title': 'Dart Basics',
      'uploader': 'Dart Dev',
      'uploaderIcon': 'https://via.placeholder.com/50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];

          return GestureDetector(
            onTap: () {
              // 動画情報画面に遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoShowScreen(video: video),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // サムネイル画像をAspectRatioで5:2に設定
                  AspectRatio(
                    aspectRatio: 5 / 3, // 横:縦 = 5:2 の比率
                    child: Image.network(
                      video['thumbnail']!,
                      fit: BoxFit.cover, // 画像が比率内に収まるように表示
                      width: double.infinity, // 横幅いっぱいに表示
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // 投稿者アイコン
                      CircleAvatar(
                        backgroundImage: NetworkImage(video['uploaderIcon']!),
                      ),
                      SizedBox(width: 10),
                      // タイトルと投稿者名
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(video['uploader']!),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
