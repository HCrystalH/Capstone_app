import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_android_app/Authentication/login.dart';
import 'package:my_android_app/Screens/home_screen.dart';
// import 'package:my_android_app/Screens/main_screen.dart';
import 'package:my_android_app/Screens/user_screen.dart';
import './services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            
            // print(snapshot.data!.emailVerified);
            dynamic type;
            if(snapshot.data!.emailVerified){
              type = "googleUser";
            }else {type = "default";}
            // final getuserType = supporter!.getUserInfor(snapshot.data!.uid,'name');
            return HomeScreen(userType: '$type',);
          }else{
            return const LoginPage();
          }
        },
      ),
      // home: UserScreen()
    );
  }
}
