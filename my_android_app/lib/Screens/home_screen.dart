// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/history_screen.dart';
import 'package:my_android_app/Screens/main_screen.dart';
import 'package:my_android_app/Screens/power_screen.dart';
// import 'package:my_android_app/Screens/main_screen.dart';
import 'package:my_android_app/Screens/settings_screen.dart';
// import 'package:my_android_app/Authentication/login.dart';
import 'package:my_android_app/Screens/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String? userType;
  HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final PageController _pageController = PageController();
  int _currentIndex = 0;  
  User? user = FirebaseAuth.instance.currentUser ;
  String? gotUID;
 
  /*Declared variables END*/ 
  
  @override
  void initState() {
    debugPrint(widget.userType);
    super.initState();
    initVariables();  // get UID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(253, 230, 235, 243),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Manage Home',style:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        )),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children:  [
          MainScreen(uid: '$gotUID'),
          UserScreen(uid: '$gotUID'),
          const SettingsScreen(),
          const ChartScreen(),
          const PowerConsumptionScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "User Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Chart",
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.energy_savings_leaf),
            label: "Power Consumption",
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 121, 180, 137),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index){
          // Handle navigation or any other action based on the selected index
          if(mounted == true){
            setState(() {
              _currentIndex = index; 
            }
             
            );
            debugPrint('Tapped on item $index');
          }
          // _pageController.animateToPage(
          //   _currentIndex, 
          //   duration: const Duration(milliseconds: 100), 
          //   curve: Curves.ease
          // );  
        },
        
      ),
     
    );
  }

  void initVariables(){
    // debugPrint(user.toString());
    gotUID = user!.uid;
  }

  @override void deactivate() {
    
    _pageController.dispose();
    super.deactivate();
  }
}

  

  