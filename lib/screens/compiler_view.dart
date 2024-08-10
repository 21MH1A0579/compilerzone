import 'package:flutter/material.dart';

class FileDetailScreen extends StatelessWidget {
  final String language;
  final String code;

  FileDetailScreen({required this.language, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Language: $language"),
            SizedBox(height: 10),
            Text("Code: $code"),
          ],
        ),
      ),
    );
  }
}
