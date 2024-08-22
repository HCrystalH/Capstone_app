import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/main_screen.dart';
// import 'package:my_android_app/Screens/main_screen.dart';
import 'package:my_android_app/Screens/settings_screen.dart';
// import 'package:my_android_app/Authentication/login.dart';
import 'package:my_android_app/Screens/user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;  
  
  /*Declared variables END*/ 

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
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  const UserScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children:  const [
          MainScreen(),
          SettingsScreen(),
          
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setings",)
        ],
        selectedItemColor: const Color.fromARGB(255, 121, 180, 137),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index){
          _pageController.animateToPage(
            index, 
            duration: const Duration(milliseconds: 500), 
            curve: Curves.ease);  
                 
           // Handle navigation or any other action based on the selected index
          

          setState(() {
            switch(index){
              case 0:
                _currentIndex = 0;
                break;
              case 1:
                _currentIndex = 1;
                break;
            }
        },);
        log('Tapped on item $index');
        },
        
      ),
     
    );
  }

 
}

  

  