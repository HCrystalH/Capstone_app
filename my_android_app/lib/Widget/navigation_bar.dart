import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_android_app/Screens/home_screen.dart';
import 'package:my_android_app/Screens/settings_screen.dart'; 
class NavBar extends StatefulWidget{
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>{
  final items =[
    const Icon(Icons.home, size: 30),
    const Icon(Icons.search, size: 30),
    const Icon(Icons.favorite, size: 30),
    const Icon(Icons.person, size: 30),
    const Icon(Icons.settings, size: 30)
  ];
  final screen =  const [
    // HomeScreen(),
    SettingsScreen(),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      extendBody: true,
      appBar: AppBar(
        title: const Text("HOME SCREEN"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: screen[index],
      bottomNavigationBar: CurvedNavigationBar(
        // NavigatioBar colors
        color: const Color.fromARGB(255,233,30,74),
        // selected times colors
        buttonBackgroundColor: Colors.amberAccent,
        backgroundColor: Colors.transparent,
        items: items,
        height: 60,
        index: index,
        onTap:(index) => setState(() 
          => this.index = index,  
        )
      ),
    );
  }
}