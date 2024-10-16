import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _selectedVideo;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Future<void> _pickVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadVideo() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String price = _priceController.text;

    if (_selectedVideo != null && title.isNotEmpty && description.isNotEmpty && price.isNotEmpty) {
      try {
        // Firebase Storageへの動画アップロード
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = _selectedVideo!.path.split('/').last;
        Reference ref = storage.ref().child('videos/$fileName');
        UploadTask uploadTask = ref.putFile(_selectedVideo!);

        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Firestoreに動画のメタデータを保存
        await FirebaseFirestore.instance.collection('videos').add({
          'title': title,
          'description': description,
          'price': double.parse(price), // 料金を保存
          'videoUrl': downloadUrl,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('動画が正常にアップロードされました！')),
        );

        // フォームをリセット
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        setState(() {
          _selectedVideo = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('アップロードに失敗しました: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('すべての項目を入力してください。')),
      );
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
