import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_video_model.dart';

// Firestoreからユーザーのアップロード動画を取得するStreamProvider
final userVideosProvider = StreamProvider.autoDispose<List<UserVideo>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    return Stream.value([]); // ユーザーがログインしていない場合は空のリストを返す
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('uploadvideos')
      .snapshots()
      .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => UserVideo.fromDocument(doc))
            .toList();
      });
});
