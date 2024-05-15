import 'package:firebase_auth/firebase_auth.dart';
import 'package:xwitter/app/common/models/user.model.dart';

class AuthenticateService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        nickname: nickname,
        avatarPath: "assets/avatars/man_2.png",
        bio: "",
        numberOfFollowers: 0,
        numberOfFollowings: 0,
      );

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

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: '',
        nickname: '',
        avatarPath: "assets/avatars/man_2.png",
        bio: "",
        numberOfFollowers: 0,
        numberOfFollowings: 0,
      );

      print("deu certo o login");
      return newUser;
    } catch (err) {
      print("erro no login");
      return null;
    }
  }
}
