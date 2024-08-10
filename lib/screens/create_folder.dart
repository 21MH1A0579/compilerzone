import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateFolderScreen extends StatefulWidget {
  @override
  _CreateFolderScreenState createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  final foldernameController = TextEditingController();

  void createFolder(String foldername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playgroundData = prefs.getString('playground');
    List<Map<String, dynamic>> folders = playgroundData != null
        ? List<Map<String, dynamic>>.from(jsonDecode(playgroundData))
        : [];

    Map<String, dynamic> newFolder = {foldername: []};
    folders.add(newFolder);

    await prefs.setString('playground', jsonEncode(folders));

    print(folders);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: foldernameController,
            decoration: InputDecoration(labelText: 'Folder Name'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              createFolder(foldernameController.text);
            },
            child: Text('Create Folder'),
          ),
        ],
      ),
    );
  }
}
