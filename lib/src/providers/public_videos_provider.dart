import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import '../models/public_video_model.dart';

// Firestoreから公開動画を取得するStreamProvider
final publicVideosProvider = StreamProvider.autoDispose<List<PublicVideo>>((ref) {
  return FirebaseFirestore.instance
      .collectionGroup('uploadvideos') // コレクション・グループクエリで全ユーザーのuploadvideosを参照
      .where('isPublic', isEqualTo: true) // 公開フラグがtrueの動画を取得
      .snapshots()
      .map((querySnapshot) {
        // 取得したドキュメントをPublicVideoのリストに変換
        return querySnapshot.docs
            .map((doc) => PublicVideo.fromDocument(doc))
            .toList();
      })
      .handleError((error) {
        // エラー発生時にログに出力
        developer.log('Error fetching public videos: $error');
      });
});
