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

  Future<void> logoutUser();
}

class AuthenticateService implements IAuthenticateService {
  static final AuthenticateService _singleton = AuthenticateService._internal();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  factory AuthenticateService() {
    return _singleton;
  }

  AuthenticateService._internal();

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

  @override
  Future<void> logoutUser() async {
    await firebaseAuth.signOut();
  }
}
