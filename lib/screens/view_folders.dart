import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'compiler_view.dart';

class ViewFoldersScreen extends StatefulWidget {
  @override
  _ViewFoldersScreenState createState() => _ViewFoldersScreenState();
}

class _ViewFoldersScreenState extends State<ViewFoldersScreen> {
  List<Map<String, dynamic>> folders = [];
  final List<String> languages = ["cpp", "python", "java"];
  @override
  void initState() {
    super.initState();
    loadFolders();

  }

  void loadFolders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playgroundData = prefs.getString('playground');
    if (playgroundData != null) {
      setState(() {

        folders = List<Map<String, dynamic>>.from(jsonDecode(playgroundData));
      });
    }
  }

  void addFile(String foldername) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final filenameController = TextEditingController();
        String selectedLanguage = languages[0];

        return AlertDialog(
          title: Text('Add File'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: filenameController,
                decoration: InputDecoration(labelText: 'File Name'),
              ),
              DropdownButtonFormField(
                value: selectedLanguage,
                items: languages.map((String language) {
                  return DropdownMenuItem(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedLanguage = value.toString();
                },
                decoration: InputDecoration(labelText: 'Language'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String filename = filenameController.text;

                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? playgroundData = prefs.getString('playground');
                List<Map<String, dynamic>> folders =
                List<Map<String, dynamic>>.from(jsonDecode(playgroundData!));

                for (var folder in folders) {
                  if (folder.containsKey(foldername)) {
                    folder[foldername].add({
                      filename: {"language": selectedLanguage, "code": "null"}
                    });
                    break;
                  }
                }

                await prefs.setString('playground', jsonEncode(folders));
                setState(() {
                  this.folders = folders;
                });

                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void deleteFile(String foldername, String filename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playgroundData = prefs.getString('playground');
    List<Map<String, dynamic>> folders =
    List<Map<String, dynamic>>.from(jsonDecode(playgroundData!));

    for (var folder in folders) {
      if (folder.containsKey(foldername)) {
        folder[foldername].removeWhere((file) => file.keys.first == filename);
        break;
      }
    }

    await prefs.setString('playground', jsonEncode(folders));
    setState(() {
      this.folders = folders;
    });
  }

  void deleteFolder(String foldername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playgroundData = prefs.getString('playground');
    List<Map<String, dynamic>> folders =
    List<Map<String, dynamic>>.from(jsonDecode(playgroundData!));

    folders.removeWhere((folder) => folder.containsKey(foldername));

    await prefs.setString('playground', jsonEncode(folders));
    setState(() {
      this.folders = folders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return folders.length==0?Center(child: Text("  NO Folders!!\nCreate a new one",style: TextStyle(fontSize: 22,color: Colors.red,fontWeight: FontWeight.bold),),): ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        String foldername = folders[index].keys.first;
        List files = folders[index][foldername];

        return ExpansionTile(
          title: Text(foldername),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => addFile(foldername),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Folder'),
                        content: Text('Are you sure you want to delete this folder?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              deleteFolder(foldername);
                              Navigator.pop(context);
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          children: files.map<Widget>((file) {
            String filename = file.keys.first;
            return ListTile(
              title: Text(filename),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteFile(foldername, filename),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FileDetailScreen(
                      language: file[filename]["language"],
                      code: file[filename]["code"],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
