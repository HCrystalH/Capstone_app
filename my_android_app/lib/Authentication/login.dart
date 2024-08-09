import 'package:flutter/material.dart';
import 'package:my_android_app/Home/home_screen.dart';
import 'auth.dart';
import 'signup.dart';

String email = '';

@immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*        Declare Variables       */

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  String password = '';
  bool _showPass = false;
  // Variables to check email and password are full filled or not
  bool checkEmail = false;
  bool checkPassword = false;

  // Variables to check validity of email and password
  var _emailInvalid = false;
  var _passInvalid = false;

  final AuthService _auth = AuthService();
  /* Declared Variables END */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          "assets/Images/bgapp.jpg",
                          fit: BoxFit.fill,
                        )),
                    const Positioned(
                        top: 20,
                        left: 150,
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(102, 50, 9, 234)),
                        )),
                    Positioned(
                        top: 100,
                        left: 50,
                        child: Column(children: [
                          // Username
                          usernameTextField(),
                          const SizedBox(height: 25),

                          // Password
                          passwordTextField(),
                          const SizedBox(height: 55),
                          // Login button
                          Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B75CE),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Login",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                              )),
                          const SizedBox(height: 20),
                          // Forget password
                          const Text(
                            "Forget your password? ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Login with Facebook account
                          facebookField(),
                          const SizedBox(height: 20),
                          // Login with Google account
                          googleField(),

                          // Sign up new account
                          const SizedBox(height: 20),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don\'t have an account ?',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen()));
                                    },
                                    child: const Text('Sign Up',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 121, 180, 137),
                                            fontSize: 15)),
                                  )
                                ],
                              )),
                        ])),
                  ],
                ),

                // For other ways to connect
              ],
            )));
  }

  Container usernameTextField() {
    return Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.person_outlined,
                color: Colors.black45,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 3,
                  left: 18,
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Enter your email",
                      errorText: _emailInvalid ? "Invalid email" : null,
                      hintStyle: const TextStyle(color: Colors.black45),
                      border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      checkEmail = true;
                    });
                  },
                ),
              ),
            ),
            // const Padding(
            //     padding: EdgeInsets.only(right: 15),
            //     child: Icon(
            //       Icons.check_circle,
            //       color: Colors.green,
            //     )),
          ],
        ));
  }

  Container passwordTextField() {
    return Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.lock_open_outlined,
                color: Colors.black45,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 3,
                  left: 18,
                ),
                child: TextFormField(
                  controller: _passController,
                  obscureText: !_showPass,
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                      errorText: _passInvalid
                          ? "Password length must be at least 8"
                          : null,
                      hintStyle: const TextStyle(color: Colors.black45),
                      border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                      checkPassword = true;
                    });
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: onToggleShowPass,
              child: Text(
                _showPass ? "HIDE" : "SHOW",
                style: const TextStyle(
                    color: Color.fromARGB(255, 121, 180, 137),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }

  Container facebookField() {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.lightBlue, borderRadius: BorderRadius.circular(50)),
      child: const Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Icon(
            Icons.facebook,
            size: 45,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text("Facebook account",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Container googleField() {
    return Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(50)),
        child: ElevatedButton(
          child: Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              Image.asset(
                "assets/google.png",
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Login with Google",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(163, 0, 142, 237))),
            ],
          ),
          onPressed: () {
            AuthService().signInWithGoogle().then((result) {
              if (result != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen();
                    },
                  ),
                );
              }
            });
          },
        ));
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }
}
