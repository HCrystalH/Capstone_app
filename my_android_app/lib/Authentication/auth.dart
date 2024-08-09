import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'database.dart';

class MyUser {
  final String uid;

  MyUser({required this.uid});
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  /*create user object based on FirebaseUser
  Note: FirebaseUser => User  (2023 version)
  */
  MyUser? _userFromFirebaseUser(User user) {
    return MyUser(uid: user.uid); //if user !=null
  }

  /* sign in Anonymous */
  Future signInAnon() async {
    try {
      // AuthResult => UserCredential
      UserCredential result = await auth.signInAnonymously();
      User? user = result.user;

      if (user != null) {
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /* Sign in with email and password */
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /* Sign in with google account*/
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String?> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    late String name;
    // late String email;
    // late String imageUrl;

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential authResult =
        await auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      name = user.displayName!;
      // email = user.email!;
      // imageUrl = user.photoURL!;

      // Only taking the first part of the name, i.e., First Name
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = auth.currentUser;
      assert(user.uid == currentUser?.uid);

      // print('signInWithGoogle succeeded: $user');
      debugPrint('signInWithGoogle succeeded: $user');
      return '$user';
    }

    return null;
  }

  // Register with email and password
  Future<MyUser?> registerWithEmailAndPassword(
      String paramEmail, String paramPassword) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: paramEmail, password: paramPassword);
      User? user = result.user;

      if (user != null) {
        //create a new document for the user with the uid
        await DatabaseService(uid: user.uid)
            .updateUserData(paramEmail, paramPassword);

        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  // Sign out
  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    debugPrint("User Signed Out");
  }
}
