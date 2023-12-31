import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sql_account_helper.dart';

//dùng để lưu tài khoản được "rememberMe"
class PrefHelper {
  //load tài khoản trong trường hợp được lưu
  static loadSavedCredentials(TextEditingController emailController,
      TextEditingController passwordController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('email') ?? '';
    passwordController.text = prefs.getString('password') ?? '';
  }

  //lưu tài khoản sau khi rememberMe được chọn
  static saveCredentials(bool rememberMe, TextEditingController emailController,
      TextEditingController passwordController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('rememberMe', rememberMe);
    if (rememberMe) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
    }
  }

  static clearSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('rememberMe');
    prefs.remove('email');
    prefs.remove('password');
  }
}
