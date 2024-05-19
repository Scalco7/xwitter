import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/authenticate.service.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';

abstract class IUserController {
  UserModel? loggedUser;

  Future<bool> signIn({
    required String email,
    required String password,
  });

  Future<bool> signUp({
    required String nickname,
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
  });

  Future<bool> editUser({
    required String userId,
    required String name,
    required String bio,
    required String avatarPath,
  });
}

class UserController implements IUserController {
  final IAuthenticateService authenticateService = AuthenticateService();
  final IUserService userService = UserService();
  final ITweetService tweetService = TweetService();
  final Validators validators = Validators();
  final Toasts toasts = Toasts();

  @override
  UserModel? loggedUser;

  //fazer refactor e deixar a parte de criar no banco de dados aqui e não no authenticate service

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

    UserModel? user =
        await authenticateService.loginUser(email: email, password: password);

    if (user == null) {
      toasts.showErrorToast("E-mail ou senha inválidos");
      return false;
    }

    loggedUser = user;

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

    ValidatorFailure accountValidation =
        await validators.validadeAccount(nickname, email);
    if (!accountValidation.valid) {
      toasts.showErrorToast(accountValidation.error);
      return false;
    }

    UserModel? user = await authenticateService.registerUser(
      nickname: nickname,
      email: email,
      name: name,
      password: password,
    );

    if (user == null) {
      toasts.showErrorToast("Erro, tente novamente");
      return false;
    }

    loggedUser = user;
    return true;
  }

  @override
  Future<bool> editUser({
    required String userId,
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
      id: userId,
      name: name,
      bio: bio,
      avatarPath: avatarPath,
    );

    if (newUser == null) {
      toasts.showErrorToast("Erro ao editar dados");
      return false;
    }

    loggedUser = newUser;
    return true;
  }
}
