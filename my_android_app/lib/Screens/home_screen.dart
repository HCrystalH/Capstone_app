import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 233, 22),
      body: Center(
        child: Text(
          "MAIN",
          style: TextStyle(
            fontWeight:FontWeight.bold,
            fontSize:60,
            color:Colors.black,
          ),
        ),
    ));
  }
}
