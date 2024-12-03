import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_android_app/Authentication/login.dart';
import 'package:my_android_app/Screens/home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

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
