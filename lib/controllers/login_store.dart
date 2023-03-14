import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ureport_ecaro/models/profile.dart';
import 'package:ureport_ecaro/services/auth_service.dart';
import 'package:ureport_ecaro/utils/enums.dart';

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

  @observable
  LoginStatus? result;

  @observable
  Profile? profile;

  @action
  void toggleLoading() {
    isLoading = !isLoading;
  }

  @action
  Future<void> login() async {
    toggleLoading();

    if (validateEmail() && validatePassword()) {
      result = null;

      result = await AuthService().login(
        email: emailController.text,
        password: passwdController.text,
      );

      toggleLoading();
    }
  }

  @action
  bool validateEmail() {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);

    if (!emailValid && emailController.text != "admin") {
      emailError = translation['invalid_email']!;

      return false;
    } else {
      emailError = null;
      return true;
    }
  }

  @action
  bool validatePassword() {
    if (passwdController.text.length < 6) {
      passwordError = translation['short_pw']!;
      return false;
    } else {
      passwordError = null;
      return true;
    }
  }

  void dispose() {
    emailController.dispose();
    passwdController.dispose();
  }
}
