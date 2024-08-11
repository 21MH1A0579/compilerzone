
import 'package:compilerzone/provider.dart';
import 'package:compilerzone/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/arduino-light.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';

class BaseCompilerPage extends StatefulWidget {
  const BaseCompilerPage({super.key});

  @override
  _BaseCompilerPageState createState() => _BaseCompilerPageState();
}

class _BaseCompilerPageState extends State<BaseCompilerPage> {
  String selectedlang = 'python';
  String userinput = '';
  String output = '';
  bool isloading = false;

  // Default theme
  CodeThemeData currentTheme = CodeThemeData(styles: monokaiSublimeTheme);

  final controller = CodeController(
    text: 'print("Hello, World!")',
    language: python,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      DropdownButton<String>(
                        focusColor: Colors.green,
                        iconEnabledColor: Colors.white,
                        value: selectedlang,
                        items: const [
                          DropdownMenuItem(value: 'python', child: Text('Python')),
                          DropdownMenuItem(value: 'cpp', child: Text('C++')),
                          DropdownMenuItem(value: 'java', child: Text('Java')),
                        ],
                        onChanged: (value) {

                          selectedlang = value!;
                          switch (selectedlang) {
                            case 'python':
                              setState(() {

                              });
                              controller.language = python;
                              controller.text = 'print("Hello, World!")';
                              break;
                            case 'cpp':
                              setState(() {

                              });
                              controller.language = cpp;
                              controller.text =
                              '#include <iostream>\n\nint main() {\n    std::cout << "Hello, World!";\n    return 0;\n}';
                              break;
                            case 'java':
                              setState(() {

                              });
                              controller.language = java;
                              controller.text =
                              'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}';
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.color_lens_outlined, color: Colors.white),
                    onSelected: (value) {
                      setState(() {
                        switch (value) {
                          case 'arduinoLightTheme':
                            currentTheme=CodeThemeData(styles: arduinoLightTheme);
                          case 'Monokai Sublime':
                            currentTheme = CodeThemeData(styles: monokaiSublimeTheme);
                            break;
                          case 'Atom One Dark':
                            currentTheme = CodeThemeData(styles: atomOneDarkTheme);
                            break;
                          case 'GitHub':
                            currentTheme = CodeThemeData(styles: githubTheme);
                            break;
                        }
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Monokai Sublime',
                        child: Text('Monokai Sublime'),
                      ),
                      const PopupMenuItem(
                        value: 'arduinoLightTheme',
                        child: Text('arduinoLightTheme'),
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
              data: currentTheme,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CodeField(
                  controller: controller,
                  textStyle: const TextStyle(
                    fontFamily: 'SourceCodePro',
                    fontSize: 18,
                  ),
                  minLines: 12,
                  maxLines: null,
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
                  CustomButton(icon: '{', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '}', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '<', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '>', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: '#', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'space', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'tab', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'del', controller: controller),
                  const SizedBox(width: 15),
                  CustomButton(icon: 'clear', controller: controller),
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
                enabled: true,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Enter a Value',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    userinput = value;
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
        onPressed: () async {
          setState(() {
            isloading = true;
          });
          output = await CodeCompile(controller.fullText, userinput, selectedlang);

          setState(() {
            isloading = false;
          });

          showResultModal(context, output);
        },
        child: isloading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : const Icon(Icons.play_arrow, size: 30),
      ),
    );
  }

  void showResultModal(BuildContext context, String result) {
    // Check the output type
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
                isResult
                    ? "Result"
                    : isCompilationError
                    ? "Compilation Error"
                    : "Error",
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
}
