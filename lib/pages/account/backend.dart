import 'package:flutter/material.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class AccountBackend extends SimpleBackend {
  AccountBackend(BuildContext context) : super(context);

  late IUserService userService = getService<IUserService>();

  User? get currentUser => userService.currentUser;

  Future<bool> signOut() async {
    bool done = await userService.signOut();
    return done;
  }

  Future<void> signInGoogle() async {
    LoginResult result = await userService.signInGoogle();
  }
}
