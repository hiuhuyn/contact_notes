import 'package:firebase_auth/firebase_auth.dart';
import 'package:contact_notes/core/state/data_sate.dart';

abstract class AuthRepository {
  Future<DataState<User>> signInWithGoogle();
  Future<DataState<String>> signOutWithGoogle();
  bool isCheckSignIn();
}
