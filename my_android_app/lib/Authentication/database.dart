import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  final db = FirebaseFirestore.instance;

  /*
    Function to update data
  */
  Future updateUserData(String username, String password) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
    return await userCollection.doc(uid).set({
      'username': username,
      'password': password,
    });
  }
  // Future updatePassword(String _password) async{

  //   return await FirebaseAuth.instance.currentUser!.updatePassword(_password);
  // }

  //get User Data
  Future getUserData() async {
    // return userCollection.snapshots();

    return await userCollection.get();
  }
}
