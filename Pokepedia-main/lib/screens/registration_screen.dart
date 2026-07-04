import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pokepedia/screens/home_screen.dart';
import 'package:pokepedia/screens/login_screen.dart';
import 'package:pokepedia/widgets/button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    // FIX: MediaQuery add kiya taaki UI responsive ban sake
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    // FIX: Fixed height/width hata kar screen size ka percentage use kiya
                    // Yahan 0.25 rakha hai kyunki 3 text fields hain
                    height: size.height * 0.25,
                    width: size.width * 0.7,
                    child: Lottie.asset('assets/animations/lottie2.json',
                        fit: BoxFit.contain), // Changed to contain
                  ),
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[400]),
                ),
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Use proper information",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.yellow),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                      ),
                      prefixIconColor: Colors.black,
                      suffixIcon: nameController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              onPressed: () {
                                nameController.clear();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.yellow),
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                      ),
                      prefixIconColor: Colors.black,
                      suffixIcon: emailController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              onPressed: () {
                                emailController.clear();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: obscureText,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.yellow),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      prefixIconColor: Colors.black,
                      suffixIcon: passwordController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: LoadingAnimatedButton(
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        print('Register Successful');

                        // Form validation check add kiya hai taaki khali button dabne par direct crash/error na aaye
                        if (formkey.currentState!.validate()) {
                          registerUser();
                        }
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      },
                      child: Text(
                        "Sign In",
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

  void registerUser() {
    if (passwordController.text == "") {
      Fluttertoast.showToast(
          msg: 'Password cannot be blank', backgroundColor: Colors.red);
    } else if (emailController.text == "") {
      Fluttertoast.showToast(
          msg: 'Please enter your email', backgroundColor: Colors.red);
    } else if (nameController.text == "") {
      Fluttertoast.showToast(
          msg: 'Please enter your name', backgroundColor: Colors.red);
    } else {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          var user = value.user;
          var uid = user!.uid;
          addUserData(uid);
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
      });
    }
  }

  void addUserData(String uid) {
    Map<String, dynamic> userData = {
      'name': nameController.text.trim(),
      'password': passwordController.text
          .trim(), // Note: Storing raw passwords in Firestore is generally not recommended for security!
      'email': emailController.text.trim(),
      'uid': uid,
    };
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .set(userData)
        .then((value) {
      Fluttertoast.showToast(
          msg: 'Registration Successful!', backgroundColor: Colors.green);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    });
  }
}
