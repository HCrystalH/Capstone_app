import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/home_screen.dart';
import 'package:my_android_app/Widget/snack_bar.dart';
import '../Authentication/auth.dart';
import 'signup.dart';
import '../Widget/text_field.dart';
import '../Widget/button.dart';
import '../Authentication/google_auth.dart';
import '../Authentication/forgot_password.dart';

String email = '';

@immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*        Declare Variables       */

  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String password = '';
  bool _showPass = false;
  // Variables to check email and password are full filled or not
  bool checkEmail = false;
  bool checkPassword = false;

 
  // Variables to check validity of email and password
  // var _emailInvalid = false;
  // var _passInvalid = false;

  // final AuthService _auth = AuthService();

  /* Declared Variables END */

  // Email and password authencation part
  void login() async {
    setState(() {
      isLoading = true;
    });
    // Sign up user using my own method
    String res = await AuthService().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      
      // Navigate user to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  HomeScreen(userType: 'default',),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // Show error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 3,
              child: Image.asset('assets/Images/login.jpg'),
            ),
            TextFieldInput(
                icon: Icons.person,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Enter your passord',
              textInputType: TextInputType.text,
              isPass: false,
            ),
            //   Forgot password 
            const ForgotPassword(),
            // Login button
            MyButtons(onTap: login, text: "Log In"),

            Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: Colors.black26),
                ),
                const Text("  or  "),
                Expanded(
                  child: Container(height: 1, color: Colors.black26),
                )
              ],
            ),
            // for google login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () async {
                  await FirebaseServices().signInWithGoogle();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>   HomeScreen(userType: 'googleUser',),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Image.network(
                        "https://ouch-cdn2.icons8.com/VGHyfDgzIiyEwg3RIll1nYupfj653vnEPRLr0AeoJ8g/rs:fit:456:456/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODg2/LzRjNzU2YThjLTQx/MjgtNGZlZS04MDNl/LTAwMTM0YzEwOTMy/Ny5wbmc.png",
                        height: 35,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Login with Google",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            // for phone authentication
            // const PhoneAuthentication(),

            // Don't have an account? got to signup screen
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
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
            // AuthService().signInWithGoogle().then((result) {
            //   if (result != null) {
            //     // Navigator.of(context).push(
            //     //   MaterialPageRoute(
            //     //     builder: (context) {
            //     //       return const HomeScreen();
            //     //     },
            //     //   ),
            //     // );
            //   }
            // });
          },
        ));
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  @override void deactivate() {
    
    passwordController.dispose();
    emailController.dispose();
    super.deactivate();
  }
}
