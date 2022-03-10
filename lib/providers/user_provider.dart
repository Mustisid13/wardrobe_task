import 'package:flutter/material.dart';
import 'package:wardrobe_task/model/users.dart' as model;
import 'package:wardrobe_task/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();
  model.User? get getUser => _user;

  Future<void>refreshUser() async{
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}