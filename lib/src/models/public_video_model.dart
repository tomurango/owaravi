import 'package:cloud_firestore/cloud_firestore.dart';

class PublicVideo {
  final String id;
  final String thumbnail;
  final String title;
  final String uploader;
  final String uploaderIcon;
  final bool isPublic;
  final String description;
  final String videoUrl;

  PublicVideo({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.uploader,
    required this.uploaderIcon,
    required this.isPublic,
    required this.description,
    required this.videoUrl,
  });

  // Firestoreから取得したデータを元にPublicVideoインスタンスを作成するファクトリメソッド
  factory PublicVideo.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PublicVideo(
      id: doc.id, // ドキュメントID
      thumbnail: data['thumbnailUrl'] ?? 'https://via.placeholder.com/150',
      title: data['title'] ?? 'No Title',
      uploader: data['userName'] ?? 'Unknown Uploader',
      uploaderIcon: data['userPhotoUrl'] ?? 'https://via.placeholder.com/50',
      isPublic: data['isPublic'] ?? false,
      description: data['description'] ?? 'No Description',
      videoUrl: data['videoUrl'] ?? '',
    );
  }
}
