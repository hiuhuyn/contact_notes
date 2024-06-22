import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;
  FirebaseService(this._auth, this._googleSignIn);
  User? get currentUser => FirebaseAuth.instance.currentUser;
  Future<User?> signInWithGoogle() async {
    try {
      log("sign in google");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Nếu người dùng hủy đăng nhập, trả về null
        log("huy sign in");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      log("user sign in: ${userCredential.user?.displayName}");
      return userCredential.user;
    } catch (e) {
      log("Error FirebaseService signInWithGoogle : $e");
      signOut();
      return null;
    }
  }

  Future<bool> signOut() async {
    if (currentUser != null) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      _auth = FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn();
      return true;
    } else {
      return false;
    }
  }

  Future<GoogleSignInAuthentication?> getGoogleAuth() async {
    final GoogleSignInAccount? googleUser =
        _googleSignIn.currentUser ?? await _googleSignIn.signIn();
    if (googleUser != null) {
      return await googleUser.authentication;
    }
    return null;
  }
}
