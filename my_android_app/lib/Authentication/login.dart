import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
                  const Text.rich(TextSpan(children: [
                    TextSpan(text: " Don't have an account? "),
                    TextSpan(
                        text: " Sign up ",
                        style: TextStyle(
                            color: Color(0xFF6b75CE),
                            fontWeight: FontWeight.bold)),
                  ])),
                ])),
          ],
        ),

        // For other ways to connect
      ],
    ));
  }

  Container usernameTextField() {
    return Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.person_outlined,
                color: Colors.black45,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 5,
                  bottom: 3,
                  left: 18,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Username",
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )),
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
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.lock_open_outlined,
                color: Colors.black45,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 5,
                  bottom: 3,
                  left: 18,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none),
                ),
              ),
            ),
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
          Text("Login with Facebook",
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
    );
  }
}
