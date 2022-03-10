
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import"package:wardrobe_task/model/users.dart" as model;


class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty) {
        // register the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // add user to our database
        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
        );
        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = "Some error occurred";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else{
        res = "Please enter all the fields";
      }
    } catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }
}
