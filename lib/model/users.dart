import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final Map<String,dynamic>? data;

  const User( {
    required this.email,
    required this.uid,
    required this.username,
    this.data
  });

  Map<String,dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'data':data
  };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String,dynamic>;

    return User(
      username: snap['username'],
      uid: snap['uid'],
      email: snap['email'],
      data: snap['data']
    );
  }
}
