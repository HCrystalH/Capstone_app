import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_android_app/Authentication/login.dart';
import 'package:my_android_app/Widget/snack_bar.dart';

class UserScreen extends StatefulWidget {
  final String uid; // user UID
  const UserScreen({super.key, required this.uid});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // final CollectionReference _items = FirebaseFirestore.instance.collection('users');
  final List<TextEditingController> _listOfController = [];
  final List<FocusNode> _listOfFocusNode = [];
  /*List of FocusNode supported for able to tap to empty space*/ 
  /*Focus Node END HERE*/ 

  String gotUserName='', gotUserPassword='', gotServer='', gotUserAccount='', gotUserKey='';
  bool isLoading = true; // To track loading state
  bool isPassWordChange = false;
  @override
  void initState() {
    super.initState();
    getUserInfo(widget.uid);
    
    // Create List Of Controller and FocusNode
    for(int i=0;i<5;i++) {
      _listOfController.add(TextEditingController());
      _listOfFocusNode.add(FocusNode());
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
      body:  GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _listOfController[0],
                    focusNode: _listOfFocusNode[0],
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter Name",
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _listOfController[1],
                    focusNode: _listOfFocusNode[1],
                    decoration: const InputDecoration(
                      labelText: "Broker Server",
                      hintText: "Enter Broker Server",
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller:  _listOfController[2],
                    focusNode: _listOfFocusNode[2],
                    decoration: const InputDecoration(
                      labelText: "Your Password",
                      hintText: "Enter Your New Password",
                    ),
                    onChanged:(value) {
                      if(value != gotUserPassword){
                        setState(() {
                          isPassWordChange = true;  
                        });
                      }
                    },
                    onSaved: (newValue) => {_listOfController[2]..text = newValue! },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:  _listOfController[3],
                    focusNode: _listOfFocusNode[3],
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Enter Username",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:  _listOfController[4],
                    focusNode: _listOfFocusNode[4],
                    decoration: const InputDecoration(
                      labelText: "User Key",
                      hintText: "Enter Key",
                    ),
                    obscureText: false,
                    
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Handle save changes logic
                      // updateUser (widget.uid);
                      updateUser(widget.uid, isPassWordChange);
                      
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Future<void> getUserInfo(String uid) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (document.exists) {
        Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            gotUserName = userData['name'];
            gotServer = userData['server'];
            gotUserPassword = userData['password'];
            gotUserAccount = userData['userName'];
            gotUserKey = userData['userKey'];
            isLoading = false; // Set loading to false after data is fetched

            if(gotUserName != '') {_listOfController[0].text = gotUserName;}
            if(gotServer != '') {_listOfController[1].text = gotServer;}
            if(gotUserPassword != '') {_listOfController[2].text = gotUserPassword;}
            if(gotUserAccount != '') {_listOfController[3].text = gotUserAccount;}
            if(gotUserKey != '') {_listOfController[4].text = gotUserKey;}
          });
        }
        // debugPrint(gotUserKey);
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  Future<void> updateUser (String uid, bool updatePassword) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final updatedData = {
      "name": _listOfController[0].text,
      "server": _listOfController[1].text,
      "userName": _listOfController[3].text,
      "userKey": _listOfController[4].text,
    };
    final updatedPassword = {
      'password' : _listOfController[2].text,
    };
    try {
      await userRef.update(updatedData);
      debugPrint(isPassWordChange.toString());
      bool show = false;
      if(isPassWordChange == true){
        debugPrint("UPDATING PASSWORD!!!");
        showSnackBar(context, "Updating Password ! Please wait a few seconds",customColor:const Color.fromARGB(255, 4, 223, 243),textColor: Colors.white);
        await userRef.update(updatedPassword);
        show = await _changePassword(userRef);
        // user.logOut();
      
      }
      if(show){
        // ignore: use_build_context_synchronously
        showSnackBar(context,"Update Successfully ! Please Login again",customColor: Colors.green);
        // Navigate user to home screen
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => const LoginPage(),),);
      }
    } catch (e) {
      debugPrint("Error updating user data: $e");
      // ignore: use_build_context_synchronously
      showSnackBar(context,e.toString(),customColor: Colors.red,textColor: Colors.black);
    }
  }
  Future<bool> _changePassword(DocumentReference userRef) async{
    bool success = false;
    //Create an instance of the current user.
    // ignore: await_only_futures
    var user = await FirebaseAuth.instance.currentUser!;

    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out
    // ignore: await_only_futures
    final cred = await EmailAuthProvider.credential(email: user.email!, password: gotUserPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(_listOfController[2].text).then((_) {
        success = true;
        userRef.update({'password':_listOfController[2].text});
      }).catchError((error) {
        debugPrint(error.toString());
        showSnackBar(context, error.toString(),customColor: Colors.redAccent,textColor: Colors.black);
      });
    }).catchError((err) {
      debugPrint(err.toString());
      showSnackBar(context, err.toString(),customColor: Colors.redAccent,textColor: Colors.black);
    });
    debugPrint("changed: $success");
    return success;
  }

  @override
  void dispose() {
    for(var controller in _listOfController){controller.dispose();}
    for(var focusnode in _listOfFocusNode) {focusnode.dispose();}
    super.dispose();
  }
}