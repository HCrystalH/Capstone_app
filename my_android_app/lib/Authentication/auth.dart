import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService {
  // For storing data in cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // For authentication

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // For signUp
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String name}) async {
    String res = "Some error Occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        // For register user in firebase auth with email and password
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // For adding user to our cloud firestore
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'password': password,
          'uid': credential.user!.uid,
          
        });
        res = "Successfully";
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return res;
  }

  // Log in
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // Login with created email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Your email or password is wrong! Please retry";
      }
    } catch (error) {
      return error.toString();
    }
    return res;
  }

  Future<void> changePassword(String newPassword) async {
    final FirebaseAuth firebase = FirebaseAuth.instance;
    User? currentUser = firebase.currentUser;
    currentUser!.updatePassword(newPassword);
  }
  
  // Log out
  logOut() async {
    await _auth.signOut();
  }

}
