import 'package:firebase_auth/firebase_auth.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class IAuthenticateService {
  Future<UserModel?> registerUser({
    required String nickname,
    required String email,
    required String name,
    required String password,
  });

  Future<UserModel?> loginUser({
    required String email,
    required String password,
  });
}

class AuthenticateService implements IAuthenticateService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final IUserService userService = UserService();

  @override
  Future<UserModel?> registerUser({
    required String nickname,
    required String email,
    required String name,
    required String password,
  }) async {
    late UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel newUser = await userService.createUser(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        nickname: nickname,
      );

      return newUser;
    } catch (err) {
      return null;
    }
  }

  @override
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    late UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel? user =
          await userService.getUserById(id: userCredential.user!.uid);

      return user;
    } catch (err) {
      return null;
    }
  }
}
