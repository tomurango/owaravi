import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _selectedVideo;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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

  void _uploadVideo() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (_selectedVideo != null && title.isNotEmpty && description.isNotEmpty) {
      // アップロード処理をここに追加
      print('動画をアップロード: ${_selectedVideo!.path}');
      print('タイトル: $title');
      print('概要: $description');
      // 実際のアップロード処理を追加する
    } else {
      // 必須項目が未入力の場合のエラーメッセージ
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
            Center(
              child: ElevatedButton(
                onPressed: _uploadVideo,
                child: Text('動画をアップロード'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
