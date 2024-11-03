import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

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

  String? gotUserName, gotUserPassword, gotServer, gotUserAccount, gotUserKey;
  bool isLoading = true; // To track loading state

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
          FocusScope.of(context).unfocus();
        },
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _listOfController[0]..text = gotUserName ?? '',
                    focusNode: _listOfFocusNode[0],
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter Name",
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _listOfController[1]..text = gotServer ?? '',
                    focusNode: _listOfFocusNode[1],
                    decoration: const InputDecoration(
                      labelText: "Broker Server",
                      hintText: "Enter Broker Server",
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller:  _listOfController[2]..text = gotUserPassword ?? '',
                    focusNode: _listOfFocusNode[2],
                    decoration: const InputDecoration(
                      labelText: "Your Password",
                      hintText: "Enter Your New Password",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:  _listOfController[3]..text = gotUserAccount ?? '',
                    focusNode: _listOfFocusNode[3],
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Enter Username",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:  _listOfController[4]..text = gotUserKey ?? '',
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
            gotUserPassword = userData['password'];
            gotServer = userData['server'];
            gotUserAccount = userData['userName'];
            gotUserKey = userData['userKey'];
            isLoading = false; // Set loading to false after data is fetched
          });
        }
        debugPrint(gotUserKey);
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  Future<void> updateUser (String uid) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final updatedData = {
      "name": _listOfController[0].text,
      "server": _listOfController[1].text,
      "userName": _listOfController[2].text,
      "userKey": _listOfController[3].text,
    };

    try {
      await userRef.update(updatedData);
      debugPrint("User  updated successfully!");
    } catch (e) {
      debugPrint("Error updating user data: $e");
    }
  }

  @override
  void dispose() {
    for(var controller in _listOfController){controller.dispose();}
    for(var focusnode in _listOfFocusNode) {focusnode.dispose();}
    super.dispose();
  }
}