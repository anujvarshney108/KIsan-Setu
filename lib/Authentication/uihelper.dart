import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper {
  static CustomTextField(TextEditingController controller, String text, IconData iconData, bool toHide){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
        )
        ),
      ),
    );
  }
  static CustomButton(VoidCallback voidCallback, String text) {
      return SizedBox(height: 50, width: 300,child: ElevatedButton(onPressed: (){
        voidCallback();
      }, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple,shadowColor: Colors.black),
          child: Text(text,style: TextStyle(color: Colors.white,fontSize: 20),)));

  }
  static CustomAlertBox(BuildContext context,String text){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(text),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Ok",style: TextStyle(fontSize: 18),))
        ],
      );
    });
  }
  static CustomTextField1(TextEditingController controller, String text, IconData iconData, bool toHide, VoidCallback onEyePressed){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
            hintText: text,
            suffixIcon: IconButton(onPressed: onEyePressed , icon: Icon(toHide ? Icons.visibility_off : Icons.visibility)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            )
        ),
      ),
    );
  }
}