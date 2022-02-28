import 'package:flutter/material.dart';
import 'package:yatadabaron/cloudhub/cloudhub.dart';
import 'package:yatadabaron/cloudhub/src/users/module.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:simply/simply.dart';

class AccountBackend extends SimpleBackend {
  AccountBackend(BuildContext context) : super(context);

  CloudHubUser? get currentUser => CloudHubUsers.instance.currentUser;

  Future<void> signOut() async {
    bool done = await CloudHubUsers.instance.signOut();
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
      CloudHubLoginStatus result = await CloudHubUsers.instance.signInGoogle();
      switch (result) {
        case CloudHubLoginStatus.SUCCESS:
          reloadApp();
          break;
        case CloudHubLoginStatus.ALREADY_LOGGED_IN:
          await _show("تم تسجيل الدخول بالفعل");
          break;
        case CloudHubLoginStatus.ERROR:
          await _show("خطأ أثناء تسجيل الدخول");
          break;
        case CloudHubLoginStatus.NOT_REGISTERED:
          await _show("هذا الحساب غير مسجل, برجاء تسجيل الدخول أولاً");
          break;
      }
    } catch (e) {
      await _show("خطأ أثناء تسجيل الدخول $e");
    }
  }

  Future<void> registerGoogle() async {
    try {
      CloudHubRegisterStatus result =
          await CloudHubUsers.instance.registerGoogle();
      switch (result) {
        case CloudHubRegisterStatus.SUCCESS:
          await _show("تم إنشاء الحساب بنجاح, الآن يمكنك تسجيل الدخول");
          break;
        case CloudHubRegisterStatus.ALREADY_REGISTERED:
          await _show("هذا الحساب موجود بالفعل");
          break;
        case CloudHubRegisterStatus.ERROR:
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
