
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  addNewCategory(String categoryName) async{
    try{
      await _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({
        "data.$categoryName": FieldValue.arrayUnion([""])
      });
    } catch(err){
      print(err.toString());
    }
  }

  addImageToCategory(String categoryName, String imageUrl) async{
    try{
      await _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({
        "data.$categoryName": FieldValue.arrayUnion([imageUrl])
      });
    } catch(err){
      print(err.toString());
    }
  }

  deleteData(String category)async{
    DocumentSnapshot<Map<String,dynamic>> getData = await _firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).get();
   Map<String,dynamic> data = getData.get("data");
   data.remove(category);
    _firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).update({
      "data":data
    });
  }

  updateCategoryName(String oldValue,String newValue) async{
    DocumentSnapshot<Map<String,dynamic>> getData = await _firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).get();
    Map<String,dynamic> data = getData.get("data");
    List keyData = data[oldValue];
    data.remove(oldValue);
    data[newValue] = keyData;
    _firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).update({
      "data":data
    });
  }
}