import 'package:cloudhub_sdk/cloudhub_sdk.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/pages/_viewmodels/module.dart';

class AccountBackend extends SimpleBackend {
  AccountBackend(BuildContext context) : super(context);

  UserViewModel? get currentUser {
    CloudHubUser? user = CloudHubUsers.instance.currentUser;
    if (user == null) {
      return null;
    }
    return UserViewModel(
      globalId: user.globalId,
      displayName: user.displayName,
      email: user.email,
      imageUrl: user.imageURL,
    );
  }

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
        case CloudHubLoginStatus.success:
          reloadApp();
          break;
        case CloudHubLoginStatus.alreadyLoggedIn:
          await _show("تم تسجيل الدخول بالفعل");
          break;
        case CloudHubLoginStatus.error:
          await _show("خطأ أثناء تسجيل الدخول");
          break;
        case CloudHubLoginStatus.notRegistered:
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
        case CloudHubRegisterStatus.success:
          await _show("تم إنشاء الحساب بنجاح, الآن يمكنك تسجيل الدخول");
          break;
        case CloudHubRegisterStatus.alreadyRegistered:
          await _show("هذا الحساب موجود بالفعل");
          break;
        case CloudHubRegisterStatus.error:
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
