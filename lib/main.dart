import 'package:compilerzone/screens/compiler.dart';
import 'package:compilerzone/screens/create_folder.dart';
import 'package:compilerzone/screens/view_folders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'apikey.env');
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
    BaseCompilerPage(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < pages.length) {
      setState(() {
        selectedindex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "COMPILER ZONE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.green,
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.running_with_errors_outlined),
            label: 'Online Compiler',
          ),
        ],
      ),
    );
  }
}
