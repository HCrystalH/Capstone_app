

import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:my_android_app/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authentication/auth.dart';
// import 'package:provider/provider.dart';
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final CollectionReference _items = FirebaseFirestore.instance.collection('users');
  TextEditingController userName = TextEditingController();
  String? gotEmail,gotUserPassword;
  String gotUserName ="";
  bool flagChange = true;
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    
    super.initState();
    getUserInfor('dzMsIGjedqeqtBRgC7ZiBc6mXT42',gotEmail);
    // updateUser('dzMsIGjedqeqtBRgC7ZiBc6mXT42',false);
    // debugPrint("Hello World!");
  }
  // final CarouselController controller = CarouselController(initialItem: 1);
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile'
        ,textAlign: TextAlign.center,
        style:  TextStyle(fontSize: 36,fontWeight: FontWeight.bold),
        ),
      
      ),
      body: StreamBuilder(
        stream: _items.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
        // padding: const EdgeInsets.all(16.0),
        if(streamSnapshot.hasData){
          
          
        return Padding(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextFormField(
                  controller: userName,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: gotEmail,
                      
                      labelStyle: const TextStyle(
                          color: Color(0xff888888), fontSize: 15)),
                  onChanged: (value) {
                    setState(() {
                      
                    });
                  },
                ),
              ),
              TextFormField(
                controller: userName,
                onTapOutside: (event) => nullptr,
                decoration:  InputDecoration(
                  hintText: gotUserName,
                  labelText: "Name",
                ),
                onSaved: (newValue) {
                  if(mounted){
                    setState(() {
                      gotUserName = newValue!;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Text("$gotEmail", style: TextStyle(fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 16),
              Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '$gotUserPassword', 

                ),
              ),
              const SizedBox(height: 16),
              const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: '23/05/1995',
                ),
              ),
              SizedBox(height: 16),
              const Text('Country/Region', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nigeria',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Handle save changes logic
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        );
        }
        return const Center(
          child:CircularProgressIndicator(),
        );
        }
      ),
    );
  }



Future<void> getUserInfor(String uid,dynamic input) async{
   
  final querySnapshot = await _items.where('uid', isEqualTo: uid).get();
  if(mounted == true){
     
    DocumentReference data = FirebaseFirestore.instance.collection('users').doc(uid);
    if(querySnapshot.docs.isNotEmpty){
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String,dynamic>;
        // print(data['name']);
        // print(data.toString());
        debugPrint(querySnapshot.docs.first.data().toString());
        setState(() {
          gotEmail = data['email'];
          gotUserPassword = data['password'];
          gotUserName = data['name'];
        });
        debugPrint(gotEmail);
        debugPrint(gotUserPassword);
        debugPrint(gotUserName);
    }
  }
  debugPrint("get User information completed");
}

  Future<void> updateUser(String uid, bool flagPassword) async{
    QuerySnapshot querySnapshot = await _items.where('uid', isEqualTo: uid).get();
    // Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String,dynamic>;
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    debugPrint("Starting update!");
    final password ={"name" : "Crystal Palace"};
    if(flagPassword){
      AuthService? user = AuthService();
      user.changePassword("1912002");
    }
    if(flagChange){
      // set() to add data
      userRef.set(password,SetOptions(merge: true));
      debugPrint("updated successfully");
    }

    debugPrint("updated completed!");
  }

  @override
  void dispose() {
    
    super.dispose();
  }
}

