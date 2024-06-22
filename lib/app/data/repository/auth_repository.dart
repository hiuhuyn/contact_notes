import "package:firebase_auth/firebase_auth.dart";
import "package:contact_notes/app/data/data_sources/remote/firebase_service.dart";
import "package:contact_notes/core/exceptions/custom_exception.dart";

import "package:contact_notes/core/state/data_sate.dart";

import "../../domain/repository/auth_repository.dart";

class AuthRepositoryIml implements AuthRepository {
  final FirebaseService _firebaseService;
  AuthRepositoryIml(this._firebaseService);
  @override
  Future<DataState<User>> signInWithGoogle() async {
    try {
      User? user = await _firebaseService.signInWithGoogle();
      if (user != null) {
        return DataSuccess<User>(user);
      } else {
        return DataFailed<User>(CustomException("Đăng nhập thất bại",
            errorType: ErrorType.authentication));
      }
    } catch (e) {
      return DataFailed<User>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<String>> signOutWithGoogle() async {
    try {
      if (await _firebaseService.signOut()) {
        return const DataSuccess<String>("Đăng xuất thành công");
      } else {
        return DataFailed<String>(CustomException("Đăng xuất thất bại",
            errorType: ErrorType.authentication));
      }
    } catch (e) {
      return DataFailed<String>(CustomException("Đăng xuất thất bại, $e"));
    }
  }

  @override
  bool isCheckSignIn() {
    if (_firebaseService.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
}
