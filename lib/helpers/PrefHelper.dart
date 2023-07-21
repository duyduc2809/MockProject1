import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SQLAccountHelper.dart';

class PrefHelper {


  static loadSavedCredentials(TextEditingController emailController,
      TextEditingController passwordController) async {
    var user = await SQLAccountHelper.getAccountToSave();
    if (user != null) {
      emailController.text = user['email'].toString();
      passwordController.text = user['password'].toString();
    }
  }

  static saveCredentials(bool rememberMe, TextEditingController emailController,
      TextEditingController passwordController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe);
    if (rememberMe) {
      String email = emailController.text;
      String password = passwordController.text;
      // SQLAccountHelper db = SQLAccountHelper();
      await SQLAccountHelper.saveUser(email, password);
    }
  }

  static clearSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('rememberMe');
  }


}
