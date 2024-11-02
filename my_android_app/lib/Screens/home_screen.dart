import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/main_screen.dart';
// import 'package:my_android_app/Screens/main_screen.dart';
import 'package:my_android_app/Screens/settings_screen.dart';
// import 'package:my_android_app/Authentication/login.dart';
import 'package:my_android_app/Screens/user_screen.dart';


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

  /*Declared variables END*/ 
  
  @override
  void initState() {
    print(widget.userType);
    super.initState();

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
          MainScreen(),
          const UserScreen(),
          const SettingsScreen(),
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

 
  @override void deactivate() {
    
    _pageController.dispose();
    super.deactivate();
  }
}

  

  