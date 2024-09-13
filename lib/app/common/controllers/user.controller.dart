import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/models/user_data.model.dart';
import 'package:xwitter/app/common/models/user_local_data.model.dart';
import 'package:xwitter/app/common/services/local_data.service.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class IUserController {
  UserModel? loggedUser;

  Future<bool> signInFromLocalData();

  Future<bool> signIn({
    required String email,
    required String password,
  });

  Future<bool> signOut();

  Future<bool> signUp({
    required String nickname,
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
  });

  Future<bool> editUser({
    required UserModel user,
    required String name,
    required String bio,
    required String avatarPath,
  });

  Future<UserData?> getUserData({required UserModel oldUser});
}

class UserController implements IUserController {
  static final UserController _singleton = UserController._internal();
  final IUserService userService = UserService();
  final ILocalData localDataService = LocalData();
  final ITweetService tweetService = TweetService();
  final Validators validators = Validators();
  final Toasts toasts = Toasts();

  factory UserController() {
    return _singleton;
  }

  UserController._internal();

  @override
  UserModel? loggedUser;

  @override
  Future<bool> signInFromLocalData() async {
    UserLocalDataModel? localData = await localDataService.getUserLogin();

    if (localData == null) {
      return false;
    }

    if (DateTime.now().isAfter(localData.date.add(const Duration(days: 14)))) {
      localDataService.removeUserLogin();
      return false;
    }

    loggedUser = await userService.getUserById(userId: localData.id);
    return loggedUser != null;
  }

  @override
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    await userService.userLogin(
        email: "felipinho@gmail.com", password: "123456");

    ValidatorFailure emailValidate = validators.validateEmail(email);
    ValidatorFailure passwordValidate =
        validators.validatePasswordForLogin(password);

    if (!emailValidate.valid) {
      toasts.showErrorToast(emailValidate.error);
      return false;
    }

    if (!passwordValidate.valid) {
      toasts.showErrorToast(passwordValidate.error);
      return false;
    }

    UserModel? user;

    try {
      user = await userService.userLogin(email: email, password: password);
    } catch (e) {
      toasts.showErrorToast("E-mail ou senha inválidos");
      return false;
    }

    bool success = await localDataService.saveUserLogin(user.id);
    if (!success) {
      return false;
    }

    loggedUser = user;

    return true;
  }

  @override
  Future<bool> signOut() async {
    bool success = await localDataService.removeUserLogin();

    if (!success) {
      return false;
    }

    loggedUser = null;
    return true;
  }

  @override
  Future<bool> signUp({
    required String nickname,
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
  }) async {
    ValidatorFailure nicknameValidate = validators.validateNickname(nickname);
    if (!nicknameValidate.valid) {
      toasts.showErrorToast(nicknameValidate.error);
      return false;
    }

    ValidatorFailure emailValidate = validators.validateEmail(email);
    if (!emailValidate.valid) {
      toasts.showErrorToast(emailValidate.error);
      return false;
    }

    ValidatorFailure nameValidate = validators.validateName(name);
    if (!nameValidate.valid) {
      toasts.showErrorToast(nameValidate.error);
      return false;
    }

    ValidatorFailure passwordValidate =
        validators.validatePasswordForRegister(password, confirmPassword);
    if (!passwordValidate.valid) {
      toasts.showErrorToast(passwordValidate.error);
      return false;
    }

    UserModel user;

    try {
      print("ta aqui");
      user = await userService.createUser(
          name: name, email: email, nickname: nickname, password: password);
      print("ta aqui");
    } catch (e) {
      print("ta aqui");
      return false;
    }

    bool success = await localDataService.saveUserLogin(user.id);
    if (!success) {
      return false;
    }

    loggedUser = user;
    return true;
  }

  @override
  Future<bool> editUser({
    required UserModel user,
    required String name,
    required String bio,
    required String avatarPath,
  }) async {
    ValidatorFailure nameValidate = validators.validateName(name);
    if (!nameValidate.valid) {
      toasts.showErrorToast(nameValidate.error);
      return false;
    }

    UserModel? newUser = await userService.updateUser(
      user: user,
      name: name,
      bio: bio,
      photoBase64: avatarPath,
    );

    if (newUser == null) {
      toasts.showErrorToast("Erro ao editar dados");
      return false;
    }

    loggedUser = newUser;
    return true;
  }

  @override
  Future<UserData?> getUserData({required UserModel oldUser}) async {
    UserModel? user = await userService.getUserById(
      userId: oldUser.id,
    );

    if (user == null) {
      return null;
    }

    List<TweetModel> postedTweets = await tweetService.listPostedTweets(
      user: user,
      loggedUserId: loggedUser!.id,
    );

    List<TweetModel> likedTweets = await tweetService.listLikedTweets(
      user: user,
      loggedUserId: loggedUser!.id,
    );

    UserData userData = UserData(
      user: user,
      postedTweets: postedTweets,
      likedTweets: likedTweets,
    );

    return userData;
  }
}
