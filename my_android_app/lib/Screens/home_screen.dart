import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/history_screen.dart';
import 'package:my_android_app/Screens/main_screen.dart';
import 'package:my_android_app/Screens/power_screen.dart';
import 'package:my_android_app/Screens/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_android_app/services/database.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String? userType;
  HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  
  final PageController _pageController = PageController();
  int _currentIndex = 0;  
  User? user = FirebaseAuth.instance.currentUser ;
  String? gotUID;
  SupportedUser? gotuser;
  late String server ="",username ="",userkey ="";
  /*Declared variables END*/ 
  

  @override
  void initState() {
    debugPrint(widget.userType);
    super.initState();
    initVariables();  // get UID
    
    fetchUserDataFromFirebase();
    Timer(const Duration(seconds: 1), handleToSubscribe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(253, 230, 235, 243),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: Text('Manage Home',style:TextStyle(
        //   fontWeight: FontWeight.bold,
        //   fontSize: MediaQuery.sizeOf(context).width*0.08,
        // )),
        toolbarHeight: MediaQuery.sizeOf(context).height*0.01,
        centerTitle: true,
        // backgroundColor: Colors.blueAccent,
      ),
      body:
        IndexedStack(
        index: _currentIndex,
        children:  [
          MainScreen(uid: '$gotUID',brokerServer: server,brokerUserName:username ,brokerUserKey: userkey),
          ChartScreen(brokerUserKey: userkey,brokerUserName: username,),
          const PowerConsumptionScreen(),
          UserScreen(uid: '$gotUID'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Chart",
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.energy_savings_leaf),
            label: "Power Consumption",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "User Profile",
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 121, 180, 137),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        
        // mouseCursor: MouseCursor.defer,
        onTap: (index){
          // Handle navigation or any other action based on the selected index
          if(mounted == true){
            setState(() {
              _currentIndex = index; 
              if(index == 1 || index == 2){
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                  
                ]);
              }
              if(index == 0 || index == 3){
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
              }
            }
            );
          }
        },
      ),
    );
  }

  void initVariables(){
    // debugPrint(user.toString());
    gotUID = user!.uid;
  }
  Future<void> fetchUserDataFromFirebase( ) async{
    try{
      gotuser = SupportedUser(gotUID!);
      gotuser!.getUserInfor( 'userName').then((String result){
        if(result != "Do not have certain data!!!")  setState( () {username = result;}); 
      }); // add cast to avoid incompatible type String != Future<String>
      gotuser!.getUserInfor( 'userKey').then((String result){
        // debugPrint(result);
          if(result != "Do not have certain data!!!") setState( () {userkey = result;}); 
      });
      gotuser!.getUserInfor( 'server').then((String result){
        // debugPrint(result);
          if(result != "Do not have certain data!!!") setState( () {server = result;}); 
      });
    }catch (e){
      debugPrint(e.toString());
    }
  }

  void handleToSubscribe(){
    // Callback function when use timer
    debugPrint(username);
    debugPrint(server);
    debugPrint(userkey);
    if(username == '' || userkey == ''  || server =='') {fetchUserDataFromFirebase();}
    else if(username != '' && userkey != ''  && server !='') {
      debugPrint("Ready to subscribe!");
    }
  }

  @override void deactivate() {
    
    _pageController.dispose();
    super.deactivate();
  }
}

  

  