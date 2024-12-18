import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'video_detail_screen.dart';
import '../providers/public_videos_provider.dart'; // StreamProviderをインポート

class RecommendedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoStream = ref.watch(publicVideosProvider);

    return Scaffold(
      body: videoStream.when(
        data: (videos) {
          if (videos.isEmpty) {
            return Center(child: Text('No videos available'));
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];

              return GestureDetector(
                onTap: () {
                  // 動画情報画面に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoDetailScreen(video: video),
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
                        aspectRatio: 5 / 2, // 横:縦 = 5:2 の比率
                        child: Image.network(
                          video.thumbnail,
                          fit: BoxFit.cover, // 画像が比率内に収まるように表示
                          width: double.infinity, // 横幅いっぱいに表示
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          // 投稿者アイコン
                          CircleAvatar(
                            backgroundImage: NetworkImage(video.uploaderIcon),
                          ),
                          SizedBox(width: 10),
                          // タイトルと投稿者名
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(video.uploader),
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
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
