import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/arduino-light.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider.dart';
import '../widgets.dart';

class CompilerView extends StatefulWidget {
  final String language;
  final String code;
  final String filename;
  final String foldername;

  CompilerView({super.key, required this.foldername,required this.language, required this.code, required this.filename});

  @override
  State<CompilerView> createState() => _CompilerViewState();
}

class _CompilerViewState extends State<CompilerView> {
  late CodeController _controller;
  late CodeThemeData _currentTheme;
  String userInput = '';
  String output = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTheme = CodeThemeData(styles: monokaiSublimeTheme);

    _controller = CodeController(
      text: widget.code == 'null'
          ? widget.language == 'java'
          ? 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}'
          : widget.language == 'python'
          ? 'print("Hello, World!")'
          : '#include <iostream>\n\nint main() {\n    std::cout << "Hello, World!";\n    return 0;\n}'
          : widget.code,
      language: widget.language == 'java'
          ? java
          : widget.language == 'cpp'
          ? cpp
          : python,
    );

  }

  void _setTheme(String themeName) {
    setState(() {
      switch (themeName) {
        case 'arduinoLightTheme':
          _currentTheme = CodeThemeData(styles: arduinoLightTheme);
          break;
        case 'Monokai Sublime':
          _currentTheme = CodeThemeData(styles: monokaiSublimeTheme);
          break;
        case 'Atom One Dark':
          _currentTheme = CodeThemeData(styles: atomOneDarkTheme);
          break;
        case 'GitHub':
          _currentTheme = CodeThemeData(styles: githubTheme);
          break;
      }
    });
  }

  void _showResultModal(BuildContext context, String result) {
    bool isResult = result.startsWith("Results:");
    bool isCompilationError = result.startsWith("Compilation Error:");

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
              Text(
                isResult ? "Result" : isCompilationError ? "Compilation Error" : "Error",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isResult ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                result,
                style: TextStyle(
                  fontSize: 16,
                  color: isResult ? Colors.green : Colors.red,
                ),
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

  Future<void> _compileCode() async {
    setState(() {
      isLoading = true;
    });

    output = await CodeCompile(_controller.fullText, userInput, widget.language);

    setState(() {
      isLoading = false;
    });

    _showResultModal(context, output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.filename,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.brown,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.brown,
              height: 60,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Language:", style: TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(width: 20),
                      Text(widget.language, style: const TextStyle(color: Colors.blue, fontSize: 25)),
                      TextButton(onPressed: (){
                        saveData(_controller.fullText,widget.filename);
                      }, child: Icon(Icons.save))
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.color_lens_outlined, color: Colors.white),
                    onSelected: _setTheme,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Monokai Sublime',
                        child: Text('Monokai Sublime'),
                      ),
                      const PopupMenuItem(
                        value: 'arduinoLightTheme',
                        child: Text('Arduino Light Theme'),
                      ),
                      const PopupMenuItem(
                        value: 'Atom One Dark',
                        child: Text('Atom One Dark'),
                      ),
                      const PopupMenuItem(
                        value: 'GitHub',
                        child: Text('GitHub'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CodeTheme(
              data: _currentTheme,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CodeField(
                  controller: _controller,
                  textStyle: const TextStyle(
                    fontFamily: 'SourceCodePro',
                    fontSize: 18,
                  ),
                  minLines: 12,
                  maxLines: 15, // Allow the CodeField to grow with content
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("Keys :", style: TextStyle(color: Colors.green, fontSize: 28)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(icon: '{', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '}', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '<', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '>', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '#', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'space', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'tab', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'del', controller: _controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'clear', controller: _controller),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("Input :", style: TextStyle(color: Colors.green, fontSize: 28)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: TextField(
                cursorColor: Colors.white,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Enter a Value',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    borderSide: const BorderSide(
                      color: Colors.white, // White border when not focused
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    borderSide: const BorderSide(
                      color: Colors.green, // Green border when focused
                      width: 2.0, // Thickness of the border
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                ),
                style: const TextStyle(color: Colors.white), // Text color
                onChanged: (value) {
                  setState(() {
                    userInput = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Compile',
        backgroundColor: Colors.green.shade700,
        onPressed: _compileCode,
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : const Icon(Icons.play_arrow, size: 30),
      ),
    );
  }

  void saveData(String fullText, String filename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the existing data from SharedPreferences
    String? playgroundData = prefs.getString('playground');
    if (playgroundData == null) return;

    var data = jsonDecode(playgroundData);

    // Check if 'playground' is a list
    if (data is List) {
      for (var folder in data) {
        if (folder.containsKey(widget.foldername)) {
          List files = folder[widget.foldername];

          for (var file in files) {
            if (file.containsKey(filename)) {
              file[filename]['code'] = _controller.fullText;
              file[filename]['language'] = widget.language;
            }
          }
        }
      }
    }
setState(() {

});
    // Save the updated data back to SharedPreferences
    prefs.setString('playground', jsonEncode(data));

  }


}
