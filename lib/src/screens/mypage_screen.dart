import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_video_model.dart';
import '../providers/user_videos_provider.dart';

class MyPageScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userVideosAsyncValue = ref.watch(userVideosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
      ),
      body: userVideosAsyncValue.when(
        data: (videos) => videos.isEmpty
            ? Center(child: Text('アップロードされた動画がありません'))
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          // サムネイル画像の表示
                          Image.network(
                            video.thumbnail,
                            width: 150,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          // タイトルの表示
                          Text(
                            video.title,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
      ),
    );
  }
}
