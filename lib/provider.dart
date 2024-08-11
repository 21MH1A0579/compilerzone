
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final urlheaders = {
  "x-rapidapi-host": "judge0-ce.p.rapidapi.com",
  "x-rapidapi-key": dotenv.get("API_KEY"), // Ensure .env file contains API_KEY
  "content-type": "application/json",
  "accept": "application/json",
};

// Base64 Decoder
String _decodeBase64(String base64Str) {
  try {
    final decodedBytes = base64.decode(base64Str);
    return utf8.decode(decodedBytes);
  } catch (e) {
    return 'Error decoding base64: $e';
  }
}

// Function to fetch the compilation result
Future<String> CompilationResult(String token) async {
  try {
    while (true) {
      final response = await http.get(
        Uri.parse('https://judge0-ce.p.rapidapi.com/submissions/$token?base64_encoded=true'),
        headers: urlheaders,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']['description'] == 'Accepted') {
          return 'Results:\n${_decodeBase64(jsonResponse['stdout'])}\nExecution Time: ${jsonResponse['time']} secs\nMemory Used: ${jsonResponse['memory']} bytes';
        } else if (jsonResponse['stderr'] != null) {
          return 'Error:\n${_decodeBase64(jsonResponse['stderr'])}';
        } else if (jsonResponse['compile_output'] != null) {
          return 'Compilation Error:\n${_decodeBase64(jsonResponse['compile_output'])}';
        }
      } else {
        return 'Error: \n fetching status: ${response.body}';
      }

      // Wait for a while before checking the status again
      await Future.delayed(Duration(seconds: 1));
    }
  } catch (e) {
    return 'Exception: $e';
  }
}

// Function to get the language ID
int GetLangId(String lang) {
  switch (lang) {
    case 'python':
      return 71;
    case 'cpp':
      return 54;
    case 'java':
      return 62;
    default:
      return 71;
  }
}

// Function to compile the code
Future<String> CodeCompile(String code, String entered_data, String language) async {
  print(code);
  final urlbody = jsonEncode({
    "source_code": code,
    "stdin": entered_data,
    "language_id": GetLangId(language),
  });

  try {
    final response = await http.post(
      Uri.parse('https://judge0-ce.p.rapidapi.com/submissions'),
      headers: urlheaders,
      body: urlbody,
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return CompilationResult(json['token']);
    } else {
      return 'Error: \n ${response.body}';
    }
  } catch (e) {
    return 'Exception: $e';
  }
}



