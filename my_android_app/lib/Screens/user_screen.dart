import 'package:flutter/material.dart';
import 'package:my_android_app/Screens/home_screen.dart';



class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isSwitch = false;
 
  // final CarouselController controller = CarouselController(initialItem: 1);
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon:const  Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        ),
        centerTitle: true,
        title: const Text('Edit Profile'
        ,textAlign: TextAlign.center,
        style:  TextStyle(fontSize: 36,fontWeight: FontWeight.bold),
        ),
        
        actions: [

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Melissa Peters',
                ),
              ),
              SizedBox(height: 16),
              Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'melpeters@gmail.com',
                ),
              ),
              SizedBox(height: 16),
              Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter password', 

                ),
              ),
              SizedBox(height: 16),
              Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: '23/05/1995',
                ),
              ),
              SizedBox(height: 16),
              Text('Country/Region', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nigeria',
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Handle save changes logic
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}