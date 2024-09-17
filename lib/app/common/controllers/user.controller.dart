import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/mention_user.model.dart';
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
    required String? photoBase64,
  });

  Future<UserData?> getUserData({required UserModel oldUser});

  Future<TweetModel> toogleSaveTweet({required TweetModel tweet});

  Future<List<MentionUserModel>> searchMentionsUsers({required String prefix});
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
      user = await userService.createUser(
          name: name, email: email, nickname: nickname, password: password);
    } catch (e) {
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
    required String? photoBase64,
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
      photoBase64: photoBase64,
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

    List<TweetModel> postedTweets =
        await tweetService.listPostedTweets(userId: user.id);

    List<TweetModel> likedTweets =
        await tweetService.listLikedTweets(userId: user.id);

    UserData userData = UserData(
      user: user,
      postedTweets: postedTweets,
      likedTweets: likedTweets,
    );

    return userData;
  }

  @override
  Future<TweetModel> toogleSaveTweet({required TweetModel tweet}) async {
    bool success = false;

    if (tweet.isSaved) {
      success = await userService.unsaveTweet(tweetId: tweet.id);
    } else {
      success = await userService.saveTweet(tweetId: tweet.id);
    }

    if (!success) {
      String text = tweet.isSaved ? "deixar de salvar" : "salvar";
      toasts.showErrorToast("Erro ao $text post");
      return tweet;
    }

    tweet.isSaved = !tweet.isSaved;
    return tweet;
  }

  @override
  Future<List<MentionUserModel>> searchMentionsUsers({required String prefix}) {
    return userService.searchMentionsUsers(prefix: prefix);
  }
}
