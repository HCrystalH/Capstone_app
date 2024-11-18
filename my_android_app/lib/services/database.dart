import 'package:cloud_firestore/cloud_firestore.dart';


class SupportedUser {
  final String _uid;
  SupportedUser(String uid) : _uid = uid;

  Future<String> getUserInfor(String dataWantToGet) async{
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    
    if(document.exists){
      Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
      if(userData[dataWantToGet] != null) {return userData[dataWantToGet];}
      else {return "Do not have certain data!!!";}
    }else{
      return "Cannot fetch data";
    }
    
    // final CollectionReference items = FirebaseFirestore.instance.collection('users');
    // // QuerySnapshot querySnapshot = await _items.get();
    // QuerySnapshot querySnapshot = await items.where('uid', isEqualTo: uid).get();
    // // print(querySnapshot.docs.first.data().toString());
    // Map<String, dynamic> result = querySnapshot.docs.first.data() as Map<String,dynamic>;


    // // ignore: avoid_print
    // // print(result.toString());
    // return result[dataWantToGet];
    
  }
}