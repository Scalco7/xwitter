import 'package:email_validator/email_validator.dart';
import 'package:xwitter/app/common/error/validatorFailure.model.dart';

class Validators {
  ValidatorFailure validateEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    String error = isValid ? "" : "E-mail inválido";
    return ValidatorFailure(error: error, valid: isValid);
  }

  ValidatorFailure validatePassword(String password) {
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
}
