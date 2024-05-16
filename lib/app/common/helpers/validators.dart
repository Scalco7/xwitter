import 'package:email_validator/email_validator.dart';
import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/services/dataBase.service.dart';

class Validators {
  ValidatorFailure validateEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    String error = isValid ? "" : "E-mail inválido";
    return ValidatorFailure(error: error, valid: isValid);
  }

  ValidatorFailure validatePasswordForLogin(String password) {
    bool valid = true;
    String error = "";

    if (password.isEmpty || password == "") {
      valid = false;
      error = "Digite uma senha";
    } else if (password.length < 6) {
      valid = false;
      error = "E-mail ou senha inválidos";
    }
    return ValidatorFailure(error: error, valid: valid);
  }

  ValidatorFailure validatePasswordForRegister(
      String password, String confirmPassword) {
    bool valid = true;
    String error = "";

    if (password.isEmpty || password == "") {
      valid = false;
      error = "Digite uma senha";
    } else if (password.length < 6) {
      valid = false;
      error = "Digite uma senha com mais de 6 caracteres";
    } else if (confirmPassword.isEmpty || confirmPassword == "") {
      valid = false;
      error = "Digite a confirmação da senha";
    } else if (confirmPassword != password) {
      valid = false;
      error = "Digite senhas iguais";
    }

    return ValidatorFailure(error: error, valid: valid);
  }

  ValidatorFailure validateNickname(String nickname) {
    bool valid = true;
    String error = "";

    if (nickname.isEmpty || nickname == "") {
      valid = false;
      error = "Digite um apelido";
    } else if (nickname.length < 4) {
      valid = false;
      error = "Digite um apelido com mais de 4 caracteres";
    } else if (nickname.contains(" ")) {
      valid = false;
      error = "Digite um apelido sem espaços";
    }

    return ValidatorFailure(error: error, valid: valid);
  }

  ValidatorFailure validateName(String name) {
    bool valid = true;
    String error = "";

    if (name.isEmpty || name == "") {
      valid = false;
      error = "Digite um nome";
    }

    return ValidatorFailure(error: error, valid: valid);
  }

  Future<ValidatorFailure> validadeAccount(
      String nickname, String email) async {
    DataBaseService dataBaseService = DataBaseService();

    String? id = await dataBaseService.getUserIdByEmail(email: email);
    if (id != null) {
      return ValidatorFailure(error: "Email já está em uso", valid: false);
    }

    id = await dataBaseService.getUserIdByNickname(nickname: nickname);
    if (id != null) {
      return ValidatorFailure(error: "Nickname já está em uso", valid: false);
    }

    return ValidatorFailure(error: "", valid: true);
  }
}
