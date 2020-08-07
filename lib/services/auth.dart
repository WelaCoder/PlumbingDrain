import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/services/database.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:pet_walker/src/models/User.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:pet_walker/src/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  // FacebookLogin _facebookLogin = FacebookLogin();
  // return custom user
  User _customUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Firebase authchange Stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_customUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _customUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with google
  // Future signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final FirebaseUser user =
  //         (await _auth.signInWithCredential(credential)).user;
  //     await _initiateUser(user);
  //     return _customUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with facebook
  // Future signInWithFacebook() async {
  //   try {
  //     FacebookLoginResult result =
  //         await _facebookLogin.logIn(['email', 'public_profile']);
  //     switch (result.status) {
  //       case FacebookLoginStatus.loggedIn:
  //         final AuthCredential credential = FacebookAuthProvider.getCredential(
  //           accessToken: result.accessToken.token,
  //         );
  //         final AuthResult authResult =
  //             await _auth.signInWithCredential(credential);
  //         final FirebaseUser user = authResult.user;

  //         await _initiateUser(user);
  //         return _customUser(user);
  //         break;
  //       default:
  //         print('could not sign in with facebook in auth');
  //         return null;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // register with email and password
  Future signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).initiateData(username);
      // await _initiateUser(user);
      return _customUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
