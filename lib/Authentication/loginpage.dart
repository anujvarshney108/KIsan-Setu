import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kisan_setu/Authentication/forgotpasswoprd.dart';
import 'package:kisan_setu/Authentication/signup.dart';
import 'package:kisan_setu/Authentication/uihelper.dart';
import 'package:kisan_setu/homeScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ------------------------------------------------------------
  // CONTROLLERS
  // ------------------------------------------------------------

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  bool isLoading = false;

  // ------------------------------------------------------------
  // LOGIN FUNCTION
  // ------------------------------------------------------------

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      UiHelper.CustomAlertBox(context, "Enter Required Fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (ex) {
      if (!mounted) return;

      if (ex.code == 'invalid-credential') {
        UiHelper.CustomAlertBox(context, "Invalid email or password.");
      } else if (ex.code == 'invalid-email') {
        UiHelper.CustomAlertBox(context, "Please enter a valid email address.");
      } else if (ex.code == 'user-disabled') {
        UiHelper.CustomAlertBox(context, "This account has been disabled.");
      } else {
        UiHelper.CustomAlertBox(context, ex.message ?? "Login failed.");
      }
    } catch (e) {
      if (!mounted) return;

      UiHelper.CustomAlertBox(
        context,
        "Something went wrong. Please try again.",
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          // ======================================================
          // 1. YOUR PROVIDED IMAGE AS FULL BACKGROUND
          // ======================================================
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // ======================================================
          // 2. COVER THE STATIC LOGIN UI FROM THE IMAGE
          //
          // This creates a clean area where our real Flutter
          // widgets will be displayed.
          // ======================================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,

            // Adjust this value if required for your device.
            height: size.height * 0.59,

            child: ClipPath(
              clipper: LoginPanelClipper(),

              child: Container(
                color: Colors.white,

                padding: EdgeInsets.only(
                  left: size.width * 0.12,
                  right: size.width * 0.12,

                  // Space required because of the curved top.
                  top: size.height * 0.075,

                  bottom: 20,
                ),

                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    children: [
                      // ==================================================
                      // EMAIL FIELD
                      // ==================================================
                      SizedBox(height: 25,),
                      Container(
                        height: 65,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(40),

                          border: Border.all(
                            color: const Color(0xFFB7C8B5),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: emailController,

                          keyboardType: TextInputType.emailAddress,

                          textInputAction: TextInputAction.next,

                          style: const TextStyle(
                            fontSize: 19,
                            color: Colors.black87,
                          ),

                          decoration: const InputDecoration(
                            border: InputBorder.none,

                            hintText: "Email",

                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF999999),
                            ),

                            prefixIcon: Icon(
                              Icons.email_outlined,
                              size: 30,
                              color: Color(0xFF3A7D32),
                            ),

                            contentPadding: EdgeInsets.symmetric(
                              vertical: 19,
                              horizontal: 10,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // PASSWORD FIELD
                      // ==================================================
                      Container(
                        height: 65,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(40),

                          border: Border.all(
                            color: const Color(0xFFB7C8B5),
                            width: 1.5,
                          ),
                        ),

                        child: TextField(
                          controller: passwordController,

                          obscureText: !passwordVisible,

                          textInputAction: TextInputAction.done,

                          onSubmitted: (_) {
                            login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          },

                          style: const TextStyle(
                            fontSize: 19,
                            color: Colors.black87,
                          ),

                          decoration: InputDecoration(
                            border: InputBorder.none,

                            hintText: "Password",

                            hintStyle: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF999999),
                            ),

                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 30,
                              color: Color(0xFF3A7D32),
                            ),

                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },

                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,

                                size: 29,

                                color: const Color(0xFF555555),
                              ),
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 19,
                              horizontal: 10,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 27),

                      // ==================================================
                      // LOGIN BUTTON
                      // ==================================================
                      SizedBox(
                        width: double.infinity,
                        height: 65,

                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8E24AA),

                            disabledBackgroundColor: const Color(0xFF8E24AA),

                            elevation: 6,

                            shadowColor: Colors.black38,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),

                          child: isLoading
                              ? const SizedBox(
                                  height: 28,
                                  width: 28,

                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Login",

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // SIGNUP
                      // ==================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text(
                            "Already have an account?",

                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                              );
                            },

                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(left: 5),
                            ),

                            child: const Text(
                              "Signup",

                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,

                                color: Color(0xFF8E24AA),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),

                      // ==================================================
                      // FORGOT PASSWORD
                      // ==================================================
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPass(),
                            ),
                          );
                        },

                        child: const Text(
                          "Forgot Password",

                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,

                            color: Color(0xFF8E24AA),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// CUSTOM CURVED LOGIN PANEL
// ================================================================

class LoginPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Start from left side
    path.moveTo(0, 95);

    // ------------------------------------------------------------
    // LEFT CURVE
    // ------------------------------------------------------------

    path.quadraticBezierTo(size.width * 0.12, 20, size.width * 0.30, 5);

    // ------------------------------------------------------------
    // CENTER WAVE
    // ------------------------------------------------------------

    path.quadraticBezierTo(size.width * 0.48, -10, size.width * 0.63, 45);

    // ------------------------------------------------------------
    // RIGHT WAVE
    // ------------------------------------------------------------

    path.quadraticBezierTo(size.width * 0.80, 100, size.width, 55);

    // Right edge
    path.lineTo(size.width, size.height);

    // Bottom
    path.lineTo(0, size.height);

    // Close
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
