// writing functions for making all api calls here
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//get language id
int GetLangId(String lang) {
  switch (lang) {
    case 'python':
      return 71; // Python
    case 'cpp':
      return 54; // C++
    case 'java':
      return 62; // Java
    default:
      return 71; // Default to Python
  }
}
// Code Compilation
CodeCompile(String code,String language) async{
  final urlheaders = {
    "x-rapidapi-host": "judge0-ce.p.rapidapi.com",
    "x-rapidapi-key":  dotenv.get("API_KEY"),
    "content-type": "application/json",
    "accept": "application/json",
  };
  final urlbody = jsonEncode({
    "source_code": code,
    "stdin": "",
    "language_id": GetLangId(language),
  });
  try {
    final response = await http.post(
        Uri.parse('https://judge0-ce.p.rapidapi.com/submissions'),
        headers: urlheaders,
      body: urlbody,
    );
   if(response.statusCode==201)
     {
        final json=jsonDecode(response.body);

     }
   else{
     print("Error Occured");
   }
  }
  catch(e){
    print(e);
  }

}





