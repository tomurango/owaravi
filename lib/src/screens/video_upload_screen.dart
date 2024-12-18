import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _selectedVideo;
  File? _selectedThumbnail;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  bool isPickingFile = false;

  // 動画ファイルを選択する関数
  Future<void> _pickVideoFile() async {
    if (isPickingFile) return; // 他のファイル選択中は処理しない
    setState(() {
      isPickingFile = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null) {
        setState(() {
          _selectedVideo = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print("Error picking video file: $e");
    } finally {
      setState(() {
        isPickingFile = false;
      });
    }
  }

  // サムネイルファイルを選択する関数
  Future<void> _pickThumbnail() async {
    if (isPickingFile) return; // 他のファイル選択中は処理しない
    setState(() {
      isPickingFile = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _selectedThumbnail = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print("Error picking thumbnail file: $e");
    } finally {
      setState(() {
        isPickingFile = false;
      });
    }
  }
  /*Future<void> _pickVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickThumbnail() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
        setState(() {
        _selectedThumbnail = File(result.files.single.path!);
        });
    }
  }*/


  Future<void> _uploadVideo() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String price = _priceController.text;

    if (_selectedVideo != null && _selectedThumbnail != null && title.isNotEmpty && description.isNotEmpty && price.isNotEmpty) {
        try {
        FirebaseStorage storage = FirebaseStorage.instance;
        String videoFileName = _selectedVideo!.path.split('/').last;
        String thumbnailFileName = _selectedThumbnail!.path.split('/').last;
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // 動画アップロード
        Reference videoRef = storage.ref().child('users/$userId/videos/$videoFileName');
        UploadTask videoUploadTask = videoRef.putFile(_selectedVideo!);
        TaskSnapshot videoSnapshot = await videoUploadTask.whenComplete(() => null);
        String videoDownloadUrl = await videoSnapshot.ref.getDownloadURL();

        // サムネイルアップロード
        Reference thumbnailRef = storage.ref().child('users/$userId/thumbnails/$thumbnailFileName');
        UploadTask thumbnailUploadTask = thumbnailRef.putFile(_selectedThumbnail!);
        TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask.whenComplete(() => null);
        String thumbnailDownloadUrl = await thumbnailSnapshot.ref.getDownloadURL();

        // Firestoreに動画とサムネイルのメタデータを保存
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('uploadvideos').add({
            'title': title,
            'description': description,
            'price': double.parse(price), // 料金
            'videoUrl': videoDownloadUrl,
            'thumbnailUrl': thumbnailDownloadUrl,
            'isPublic': true, // 公開フラグをtrueに設定
            'createdAt': Timestamp.now(),
            // 投稿者名
            'userName': FirebaseAuth.instance.currentUser!.displayName,
            // 投稿者のプロフィール画像URL
            'userPhotoUrl': FirebaseAuth.instance.currentUser!.photoURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('動画が正常にアップロードされました！')));

        // フォームのリセット
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        setState(() {
            _selectedVideo = null;
            _selectedThumbnail = null;
        });
        } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('アップロードに失敗しました: $e')));
        }
    } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('すべての項目を入力してください。')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('動画アップロード'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '動画ファイルを選択:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickVideoFile,
                child: Text(_selectedVideo == null
                    ? 'ファイルを選択'
                    : '選択済み: ${_selectedVideo!.path.split('/').last}'),
              ),
              SizedBox(height: 16),
             // サムネイル画像のプレビュー
            if (_selectedThumbnail != null)
                Column(
                children: [
                    Text('選択したサムネイルプレビュー:'),
                    SizedBox(height: 8),
                    Image.file(
                    _selectedThumbnail!,
                    width: 200,  // 画像の幅を指定
                    height: 150, // 画像の高さを指定
                    fit: BoxFit.cover, // 画像が枠内に収まるように表示
                    ),
                ],
                ),
              Text(
                'サムネイル画像を選択:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickThumbnail,
                child: Text(_selectedThumbnail == null
                    ? 'ファイルを選択'
                    : '選択済み: ${_selectedThumbnail!.path.split('/').last}'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'タイトル',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '概要',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: '料金（円）',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _uploadVideo,
                  child: Text('動画をアップロード'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
