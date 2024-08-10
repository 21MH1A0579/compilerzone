import 'package:compilerzone/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';

void main() async {
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
  String userinput = '';
  String output = '';
  bool isLoading = false;

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
          "COMPILER ZONE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.orange.shade800,
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              height: 60,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Language:"),
                      const SizedBox(width: 20),
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
                  IconButton(
                    icon: const Icon(Icons.color_lens_outlined),
                    onPressed: () {
                      // Implement theme changing logic here
                    },
                  ),
                ],
              ),
            ),
            CodeTheme(
              data: CodeThemeData(styles: monokaiSublimeTheme),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CodeField(
                  controller: controller,
                  textStyle: const TextStyle(fontFamily: 'SourceCodePro', fontSize: 18),
                  minLines: 10, // Set minimum lines to decrease the height
                   // Set maximum lines to keep the height consistent
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Input",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Input',
                ),
                onChanged: (value) {
                  setState(() {
                    userinput = value;
                  });
                },
              ),
            ),
            // if (isLoading)
            //   const Padding(
            //     padding: EdgeInsets.symmetric(vertical: 10.0),
            //     child: CircularProgressIndicator(),
            //   ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'compile',
        backgroundColor: Colors.green.shade700,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          output = await CodeCompile(controller.fullText, userinput, selectedLanguage);

          setState(() {
            isLoading = false;
          });

          _showResultModal(context, output);
        },
        child: isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):const Icon(Icons.play_arrow, size: 30),
      ),
    );
  }

  void _showResultModal(BuildContext context, String result) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Output",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                result,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                  ),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
