import 'package:firebase_auth/firebase_auth.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/database.service.dart';

class AuthenticateService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DataBaseService _dataBaseService = DataBaseService();

  Future<UserModel?> registerUser({
    required String nickname,
    required String email,
    required String name,
    required String password,
  }) async {
    late UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel newUser = await _dataBaseService.createUser(
          userCredential.user!.uid, name, email, nickname);

      return newUser;
    } catch (err) {
      return null;
    }
  }

  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    late UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel? newUser =
          await _dataBaseService.getUser(userCredential.user!.uid);

      return newUser;
    } catch (err) {
      return null;
    }
  }
}
