import 'package:shared_preferences/shared_preferences.dart';
import 'package:xwitter/app/common/models/user_local_data.model.dart';

abstract class ILocalDate {
  Future<bool> saveUserLogin(String id);

  Future<bool> removeUserLogin();

  Future<UserLocalDataModel?> getUserLogin();
}

class LocalDate implements ILocalDate {
  static const loginIdKey = "user-id";
  static const loginDateKey = "login-date";

  @override
  Future<bool> saveUserLogin(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = DateTime.now().toString();

    bool success = await prefs.setString(loginIdKey, id);
    if (!success) {
      return success;
    }

    success = await prefs.setString(loginDateKey, date);
    return success;
  }

  @override
  Future<bool> removeUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  @override
  Future<UserLocalDataModel?> getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? id = prefs.getString(loginIdKey);
    String? dateText = prefs.getString(loginDateKey);

    if (id == null || dateText == null) {
      return null;
    }

    return UserLocalDataModel(id: id, date: DateTime.parse(dateText));
  }
}
