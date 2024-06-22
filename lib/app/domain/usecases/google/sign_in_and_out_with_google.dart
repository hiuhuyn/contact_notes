import 'package:firebase_auth/firebase_auth.dart';
import 'package:contact_notes/core/state/data_sate.dart';
import 'package:contact_notes/core/utils/usecase.dart';
import '../../repository/auth_repository.dart';

class SignInAndOutWithGoogleUseCase extends UsecaseOneVariable {
  final AuthRepository _authRepository;
  SignInAndOutWithGoogleUseCase(this._authRepository);
  Future<DataState<User>> signIn() async {
    return await _authRepository.signInWithGoogle();
  }

  Future<DataState<String>> signOut() async {
    return await _authRepository.signOutWithGoogle();
  }

  bool isCheckSignIn() {
    return _authRepository.isCheckSignIn();
  }

  @override
  Future call(value) async {
    throw Exception("Not implemented");
  }
}
