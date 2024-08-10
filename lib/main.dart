import 'package:compilerzone/screens/create_folder.dart';
import 'package:compilerzone/screens/view_folders.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedindex = 0;

  final List<Widget> pages = [
    CreateFolderScreen(),
    ViewFoldersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.create_new_folder),
            label: 'Create Folder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'View Folders',
          ),
        ],
      ),
    );
  }
}
