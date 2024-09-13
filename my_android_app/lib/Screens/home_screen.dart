import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as https;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/main_screen.dart';
// import 'package:my_android_app/Screens/main_screen.dart';
import 'package:my_android_app/Screens/settings_screen.dart';
// import 'package:my_android_app/Authentication/login.dart';
import 'package:my_android_app/Screens/user_screen.dart';
import 'package:my_android_app/services/mqtt_service.dart';

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

  /* MQTT */
  String userkey = "aio_Urvv98tocEDOmtPAMqsPnWt6onBo";
  String server = 'io.adafruit.com';
  String username = 'HVVH';
  MqttHelper? user;
  final topics = ["data","Relay1","Relay2","Relay3","Relay4"];
  /* MQTT ENDS*/
  
  
  /*Declared variables END*/ 
  
  @override
  void initState() {
    print(widget.userType);
    super.initState();

    user = MqttHelper(serverAddress: server, userName: username, userKey: userkey);
    user!.mqttConnect();
    user!.mqttSubscribe('$username/feeds/${topics[1]}');
    user!.mqttSubscribe('$username/feeds/${topics[2]}');
    user!.mqttSubscribe('$username/feeds/${topics[3]}');
    user!.mqttSubscribe('$username/feeds/${topics[4]}');
    /* fetch data ENDS here */

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
      body: PageView(
        controller: _pageController,
        children:  const [
          MainScreen(),
          UserScreen(),
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
            icon: Icon(Icons.person),
            label: "User Profile",),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",),
          
        ],
        selectedItemColor: const Color.fromARGB(255, 121, 180, 137),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index){
          _pageController.animateToPage(
            index, 
            duration: const Duration(milliseconds: 500), 
            curve: Curves.ease
          );  
               
          // Handle navigation or any other action based on the selected index
          if(mounted == true){
            setState(() {
              switch(index){
                case 0:
                  _currentIndex = 0;
                  break;
                case 1:
                  _currentIndex = 1;
                  break;
                case 2:
                  _currentIndex = 2;
                  break;
                }
              },
            );
            log('Tapped on item $index');
          }
        },
        
      ),
     
    );
  }

 
  @override void deactivate() {
    
    _pageController.dispose();
    super.deactivate();
  }
}

  

  