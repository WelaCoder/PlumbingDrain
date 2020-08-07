import 'dart:wasm';

class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String username;
  final String role;
  final int balance;
  final String image;
  final String uid;
  UserData({this.balance, this.username, this.image, this.role, this.uid});
}
