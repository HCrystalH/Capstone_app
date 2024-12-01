import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/home_screen.dart';
import 'package:my_android_app/Widget/snack_bar.dart';
import '../Authentication/auth.dart';
import 'signup.dart';
import '../Widget/text_field.dart';
import '../Widget/button.dart';
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
      // ignore: use_build_context_synchronously
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
      // ignore: use_build_context_synchronously
      showSnackBar(context, res,customColor: Colors.red,textColor: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height/12),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(133, 205, 202, 1),
          centerTitle: true,
        )
      ),
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
           gradient: LinearGradient(
            colors: [
              Color.fromRGBO(133, 205, 202, 1),
              Color.fromRGBO(65, 179, 164, 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            
            ),
          ),
        ),
     
      SafeArea(
          child: SizedBox(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:height/15),
            Center(
              child: SafeArea(
                minimum: const EdgeInsets.only(left:20, right:20),
                child: Text("Welcome to Your Smart Home",
                  style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).width*0.065,
                    color: const Color.fromRGBO(226, 125, 96, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: height/60),
            SafeArea(
              
              child: Center(
              child: Text("Control Your Home with Ease",
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width*0.05,
                  height: MediaQuery.sizeOf(context).height*0.002,
                  fontStyle: FontStyle.italic,
                  color: const Color.fromRGBO(223,108,79,1),
                ),
              )
              )
            ),
            SafeArea(
              maintainBottomViewPadding: true,
              child: TextFieldInput(
                icon: Icons.person,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text
              ),
            ),
           
            SizedBox(height: height/60),
            SafeArea(
              maintainBottomViewPadding: true,
              child: TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Enter your passord',
                textInputType: TextInputType.text,
                isPass: true, 
              ),
            ),
            //   Forgot password 
            const ForgotPassword(),
            // Login button
            SizedBox(height: height/65,),
            MyButtons(onTap: login, text: "Log In"),
            SizedBox(height: height/60,),
            Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: Colors.black26),
                ),
                Text("  or  ",
                  style: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).width*0.04,
                  ),
                ),
                Expanded(
                  child: Container(height: 1, color: Colors.black26),
                )
              ],
            ),
            // for google login
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            //     onPressed: () async {
            //       await FirebaseServices().signInWithGoogle();
            //       Navigator.pushReplacement(
            //         // ignore: use_build_context_synchronously
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) =>   HomeScreen(userType: 'googleUser',),
            //         ),
            //       );
            //     },
            //     child: Row(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 8),
            //           child: Image.network(
            //             "https://ouch-cdn2.icons8.com/VGHyfDgzIiyEwg3RIll1nYupfj653vnEPRLr0AeoJ8g/rs:fit:456:456/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODg2/LzRjNzU2YThjLTQx/MjgtNGZlZS04MDNl/LTAwMTM0YzEwOTMy/Ny5wbmc.png",
            //             height: 35,
            //           ),
            //         ),
            //         const SizedBox(width: 10),
            //         const Text(
            //           "Login with Google",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 20,
            //             color: Colors.white,
            //           ),
            //           textAlign: TextAlign.center,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // for phone authentication
            // const PhoneAuthentication(),

            // Don't have an account? got to signup screen
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).width*0.045,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize:  MediaQuery.sizeOf(context).width*0.05,
                        height: MediaQuery.sizeOf(context).height*0.002,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(195, 141, 158, 1),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    ]),);
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

