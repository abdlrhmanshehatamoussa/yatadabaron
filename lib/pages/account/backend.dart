import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class AccountBackend extends SimpleBackend {
  AccountBackend(BuildContext context) : super(context);

  late IUserService userService = getService<IUserService>();
  User? get currentUser => userService.currentUser;

  Future<void> signOut() async {
    bool done = await userService.signOut();
    if (done == false) {
      Utils.showCustomDialog(
        context: myContext,
        text: "خطأ أثناء تسجيل الخروج !",
      );
    } else {
      reloadApp();
    }
  }

  Future<void> signInGoogle() async {
    try {
      LoginResult result = await userService.signInGoogle();
      switch (result) {
        case LoginResult.DONE:
          reloadApp();
          break;
        case LoginResult.ALREADY_LOGGED_IN:
          await _show("تم تسجيل الدخول بالفعل");
          break;
        case LoginResult.ERROR:
          await _show("خطأ أثناء تسجيل الدخول");
          break;
        case LoginResult.NOT_REGISTERED:
          await _show("هذا الحساب غير مسجل, برجاء تسجيل الدخول أولاً");
          break;
      }
    } catch (e) {
      await _show("خطأ أثناء تسجيل الدخول $e");
    }
  }

  Future<void> registerGoogle() async {
    try {
      RegisterResult result = await userService.registerGoogle();
      switch (result) {
        case RegisterResult.DONE:
          await _show("تم إنشاء الحساب بنجاح, الآن يمكنك تسجيل الدخول");
          break;
        case RegisterResult.ALREADY_REGISTERED:
          await _show("هذا الحساب موجود بالفعل");
          break;
        case RegisterResult.ERROR:
          await _show("خطأ أثناء تسجيل حساب جديد");
          break;
      }
    } catch (e) {
      await _show("خطأ أثناء تسجيل حساب جديد: $e");
    }
  }

  Future<void> _show(String message) async {
    await Utils.showCustomDialog(
      context: myContext,
      text: message,
      title: Localization.ERROR,
    );
  }
}
