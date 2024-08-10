import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
class CustomButton extends StatefulWidget {
    String icon;
    CodeController controller;
   CustomButton({super.key,required this.icon,required this.controller});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {




  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.green,

      highlightColor: Colors.green,


      splashRadius: 100,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.blue)
      ),

      onPressed: (){
      setState(() {
        if(widget.icon=='space') {
          widget.controller.fullText= widget.controller.fullText+" ";
        }
        else if(widget.icon=='tab') {
          widget.controller.fullText= widget.controller.fullText+"  ";
        }else if(widget.icon=='del') {
          widget.controller.fullText= widget.controller.fullText.substring(0,widget.controller.fullText.length-2);
        }else if(widget.icon=='clear') {
          widget.controller.fullText= "";
        }
        else{
          widget.controller.fullText= widget.controller.fullText+widget.icon;
        }


      });
    }, icon: Text(widget.icon,style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color:widget.icon!='X'? Colors.white:Colors.red,),), );
  }
}
