import 'package:flutter/material.dart';

// 動画の詳細情報画面
class VideoDetailScreen extends StatelessWidget {
  final Map<String, String> video;

  VideoDetailScreen({required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('動画情報'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // サムネイル画像をAspectRatioで5:3に設定
            AspectRatio(
              aspectRatio: 5 / 2, // 横:縦 = 5:3 の比率
              child: Image.network(
                video['thumbnail']!,
                fit: BoxFit.cover, // 画像が比率内に収まるように表示
                width: double.infinity, // 横幅いっぱいに表示
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                // 投稿者アイコン
                CircleAvatar(
                  backgroundImage: NetworkImage(video['uploaderIcon']!),
                ),
                SizedBox(width: 10),
                // 投稿者名
                Text(
                  video['uploader']!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            // 動画タイトル
            Text(
              video['title']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // 動画の概要（ダミーテキスト）
            Text(
              'ここに動画の概要が表示されます。動画に関する詳細情報を追加できます。',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
