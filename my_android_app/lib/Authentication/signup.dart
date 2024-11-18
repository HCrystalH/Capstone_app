import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_android_app/Authentication/auth.dart';
import 'package:my_android_app/Screens/home_screen.dart';
import 'login.dart';
import '../Widget/button.dart';
import '../Widget/text_field.dart';
import '../Widget/snack_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // For controller
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userKeyController =TextEditingController();
  final TextEditingController userNameController =TextEditingController();
  final TextEditingController serverController =TextEditingController();
  // List<bool> _listOfChecker = [false,false,false,false,false];
  
  void signUp() async {
    String error = '';
    if(emailController.text == "" || emailController.text.isValidEmail()){
      error = "Invalid Email";
    }else if(nameController.text == '' || passwordController.text == '' ||
    userKeyController.text == '' || userNameController.text == '' || serverController.text == '')
    {
      error = "Please fullfilled the above fields !!!";
    }
    if(error != ''){
      showSnackBar(context, error);
      return;
    }

    String res = await AuthService().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        server: serverController.text,
        userName: userNameController.text,
        userKey: userKeyController.text
    );
    // If successfully => navigate to the login screen
    // otherwise show the error message
    if (res == 'Successfully') {
      setState(() {
        isLoading = true;
      });
      // Navigate to the login Screen
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  HomeScreen(userType: 'default',)));
    } else {
      setState(() {
        isLoading = false;
      });
      error = res;
      // Show the error message
      // ignore: use_build_context_synchronously
      showSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // double height = MediaQuery.of(context).size.height;
    // double width  = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up",textAlign: TextAlign.center,)
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child:SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('assets/Images/signup.jpeg'),
            ),
            TextFieldInput(
              icon: Icons.person,
              textEditingController: nameController,
              hintText: 'Enter your name',
              textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.email,
              textEditingController: emailController,
              hintText: 'Enter your email',
              textInputType: TextInputType.text),
          
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Enter your passord',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            TextFieldInput(
              icon: Icons.computer,
              textEditingController: serverController, 
              hintText: 'Broker server (E.g: io.adafruit.com)', 
              textInputType: TextInputType.text,
            ),
            TextFieldInput(
              icon: Icons.people,
              textEditingController: userNameController, 
              hintText: 'Enter your username account', 
              textInputType: TextInputType.text,
            ),
            
            TextFieldInput(
              icon: Icons.key,
              textEditingController: userKeyController, 
              hintText: 'Enter your MQTT server key', 
              textInputType: TextInputType.text,
              isPass: true,
            ),
            
             const SizedBox(height: 16),
            MyButtons(onTap: signUp, text: "Sign Up"),
            const SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?",style: TextStyle(fontSize: 16),),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    " Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red,
                        fontSize: 20
                      ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  @override
  void deactivate() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    serverController.dispose();
    userNameController.dispose();
    userKeyController.dispose();
    super.deactivate();
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}