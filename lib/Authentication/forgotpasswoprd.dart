import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisan_setu/Authentication/uihelper.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailController = TextEditingController();

  forgotpassword(String email)async{
    if(email==""){
      return UiHelper.CustomAlertBox(context, "Enter Email to Reset Password");
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      UiHelper.CustomAlertBox(
        context,
        "Password Reset link has been sent to your email",
      );
    } on FirebaseAuthException catch (e) {
      UiHelper.CustomAlertBox(
        context,
        e.message ?? "Something went wrong",
      );
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(emailController, "Email", Icons.email, false),
          SizedBox(height: 30,),
          
          UiHelper.CustomButton((){
            forgotpassword(emailController.text.toString());
          }, "Reset Password")
        ],
      ),
    );
  }
}
