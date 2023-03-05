import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ureport_ecaro/services/auth_service.dart';
import 'package:ureport_ecaro/utils/enums.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  late Map<String, String> translation;

  final emailController = TextEditingController();
  final passwdController = TextEditingController();

  _LoginStoreBase(this.translation);

  @observable
  var emailError;

  @observable
  var passwordError;

  @observable
  var isLoading = false;

  @action
  void toggleLoading() {
    isLoading = !isLoading;
  }

  Future<LoginStatus?> login() async {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);

    if (!emailValid && emailController.text != "admin") {
      emailError = translation['invalid_email']!;

      return null;
    } else {
      emailError = null;
    }

    if (passwdController.text.length < 6) {
      passwordError = translation['short_pw']!;
      return null;
    } else {
      passwordError = null;
    }
    toggleLoading();

    final signInResult = await AuthService().login(
      email: emailController.text,
      password: passwdController.text,
    );

    toggleLoading();
    return signInResult;
  }

  void dispose() {
    emailController.dispose();
    passwdController.dispose();
  }
}
