import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisan_setu/Authentication/uihelper.dart';
import 'package:kisan_setu/homeScreen.dart';
import 'package:kisan_setu/main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool passwordVisible = false;
  signUp(String email,String password) async{
    if(email=="" || password==""){
      UiHelper.CustomAlertBox(context, "Enter Required Fields");
    }
    else{
      UserCredential? usercredential;
      try{
        usercredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        });
      }
      on FirebaseAuthException catch(ex){
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Signup",style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(emailcontroller, "Email", Icons.email, false),
          UiHelper.CustomTextField1(
              passwordcontroller, "Password",
              Icons.password,
              !passwordVisible,
              (){
                setState(() {
                  passwordVisible=!passwordVisible;
                });
              }
          ),
          SizedBox(height: 35,),
          UiHelper.CustomButton((){
            signUp(emailcontroller.text.toString(), passwordcontroller.text.toString());
          }, "Sign Up")
        ],
      ),
    );
  }
}
