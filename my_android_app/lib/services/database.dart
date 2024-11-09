import 'package:cloud_firestore/cloud_firestore.dart';

class SupportedUser {

  Future<String> getUserInfor(String uid,String data) async{
    final CollectionReference items = FirebaseFirestore.instance.collection('users');
    // QuerySnapshot querySnapshot = await _items.get();
    QuerySnapshot querySnapshot = await items.where('uid', isEqualTo: uid).get();
    // print(querySnapshot.docs.first.data().toString());
    Map<String, dynamic> result = querySnapshot.docs.first.data() as Map<String,dynamic>;

    // print(result['name']);
    // ignore: avoid_print
    print(result.toString());
    return result['name'];
    // for (var doc in querySnapshot.docs) {
    //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //   if(data['uid'] == uid){
    //     print("username: " + data['name'] + "\n");
    //     print("email:" + data['email']);
    //     print("password:" + data['password']);
    //     break;
    //   }else{
    //     print("ko tim thay");
    //   }
    // }
  }
}