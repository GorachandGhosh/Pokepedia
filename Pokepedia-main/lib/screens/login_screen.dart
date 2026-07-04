import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pokepedia/screens/home_screen.dart';
import 'package:pokepedia/screens/registration_screen.dart';
import 'package:pokepedia/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      setState(() {});
    });

    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    // Dynamically getting screen size to make the UI responsive
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        // This ensures the screen becomes scrollable when the keyboard opens
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    // FIX: Replaced fixed height with dynamic MediaQuery height (30% of screen)
                    height: size.height * 0.3,
                    width: size.width * 0.7,
                    child: Lottie.asset('assets/animations/lottie1.json',
                        fit: BoxFit
                            .contain), // Changed to contain so it doesn't crop weirdly
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[400]),
                ),
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Enter valid Email & Password",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }

                      if (!value.contains('@')) {
                        return "Please enter a valid email";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.yellow,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      prefixIconColor: Colors.black,
                      suffixIcon: emailController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                emailController.clear();
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: obscureText,
                    obscuringCharacter: '*',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }

                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.yellow,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor: Colors.black,
                      suffixIcon: passwordController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: LoadingAnimatedButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      print("Button Pressed");

                      if (formkey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegistrationScreen()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.yellow[400],
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Login Successful",
        backgroundColor: Colors.green,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Login Failed",
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }
}
