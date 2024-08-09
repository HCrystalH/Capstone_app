import 'package:flutter/material.dart';

import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text("SIGN UP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Color(0xFF08C5DE))),
                    const SizedBox(height: 50),
                    // Email field
                    textField("E-mail"),

                    // Password field
                    const SizedBox(height: 25),
                    textField("Password"),

                    // Confirm Password
                    const SizedBox(height: 25),
                    textField("Confirmed Password"),

                    const SizedBox(height: 30),

                    // Sign up button
                    const SizedBox(height: 20),
                    Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(
                                colors: [Color(0xFF179DDB), Color(0xFF14B9D3)]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: const Center(
                            child: Text("Sign Up",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )))),

                    const SizedBox(height: 20),
                    ElevatedButton(
                        child: const Text(
                          'Already have account? Sign in',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        })
                  ],
                ))));
  }

  Material textField(hint) {
    return Material(
        color: Colors.white,
        elevation: 5,
        shadowColor: const Color.fromARGB(255, 96, 236, 222),
        borderRadius: BorderRadius.circular(30),
        child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: hint, // for passing corresponding parameter
                  hintStyle: const TextStyle(
                      color: Colors.black38, fontWeight: FontWeight.bold),
                  border: InputBorder.none),
            )));
  }
}
