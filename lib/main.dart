
import 'package:compilerzone/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'apikey.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Compiler Zone",
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = 'python';

  final controller = CodeController(
    text: 'print("Hello, World!")',
    language: python,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "COMPILER",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.orange.shade800,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            color: Colors.white,
            height: 55,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("File Type:"),
                    const SizedBox(width: 50),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      items: const [
                        DropdownMenuItem(value: 'python', child: Text('Python')),
                        DropdownMenuItem(value: 'cpp', child: Text('C++')),
                        DropdownMenuItem(value: 'java', child: Text('Java')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                          switch (selectedLanguage) {
                            case 'python':
                              controller.language = python;
                              controller.text = 'print("Hello, World!")';
                              break;
                            case 'cpp':
                              controller.language = cpp;
                              controller.text = '#include <iostream>\n\nint main() {\n    std::cout << "Hello, World!";\n    return 0;\n}';
                              break;
                            case 'java':
                              controller.language = java;
                              controller.text = 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}';
                              break;
                          }
                        });
                      },
                    ),
                  ],
                ),
                const Icon(Icons.color_lens_outlined),
              ],
            ),
          ),
          CodeTheme(
            data: CodeThemeData(styles: monokaiSublimeTheme),
            child: SingleChildScrollView(
              child: CodeField(
                controller: controller,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 50,),
                TextButton(

                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.green.shade700)
                    ),
                    onPressed: (){

                      CodeCompile(controller.fullText, selectedLanguage);
                    }, child: Text("COMPILE",style: TextStyle(color: Colors.white,fontSize: 22),))
              ],
            ),
          )
        ],
      ),
    );
  }
}
