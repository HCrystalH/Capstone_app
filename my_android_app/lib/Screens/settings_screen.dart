import 'package:flutter/material.dart';
import 'package:my_android_app/Authentication/login.dart';
import '../Widget/button.dart';
import '../Authentication/auth.dart';
import '../Authentication/google_auth.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  final AuthService _user = AuthService();
  final FirebaseServices _googleUser = FirebaseServices();
  bool isLoading = false;
  void logout() async{
    setState(() {
      isLoading = true;
    });
    _user.logOut();
    _googleUser.googleSignOut();
    
      // Navigate user to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 233, 22),
      body: Center(
        child: SizedBox(
            // child: Column
            // ("Settings Screen",
            // style: TextStyle(
            //   fontWeight:FontWeight.bold,
            //   fontSize:60,
            //   color:Colors.black,)
            // ),
          child: MyButtons(onTap: logout,text: "Log out"),
        )
        ),
       
    );
  }

  
}
