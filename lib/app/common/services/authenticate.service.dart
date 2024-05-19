import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthenticateService {
  Future<String?> registerUser({
    required String nickname,
    required String email,
    required String name,
    required String password,
  });

  Future<String?> loginUser({
    required String email,
    required String password,
  });
}

class AuthenticateService implements IAuthenticateService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String?> registerUser({
    required String nickname,
    required String email,
    required String name,
    required String password,
  }) async {
    late UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user?.uid;
    } catch (err) {
      return null;
    }
  }

  @override
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user?.uid;
    } catch (err) {
      return null;
    }
  }
}
