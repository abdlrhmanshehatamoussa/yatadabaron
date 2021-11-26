import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/account/backend.dart';
import 'package:yatadabaron/widgets/user_avatar.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AccountBackend backend = AccountBackend(context);

    Widget _loggedIn({
      required User user,
    }) {
      return Column(
        children: [
          ListTile(
            onTap: backend.signOut,
            //TODO: Localize
            title: Text("تسجيل الخروج"),
            trailing: Icon(Icons.logout),
          )
        ],
      );
    }

    Widget _loggedOut() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //TODO: Localize
        children: [
          SignInButton(
            Buttons.Google,
            padding: EdgeInsets.all(5),
            text: "لدي حساب بالفعل",
            onPressed: backend.signInGoogle,
          ),
          SizedBox(
            height: 10,
          ),
          SignInButton(
            Buttons.Google,
            padding: EdgeInsets.all(5),
            text: "تسجيل الدخول لأول مرة",
            onPressed: backend.registerGoogle,
          ),
        ],
      );
    }

    User? user = backend.currentUser;
    bool loggedIn = user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.ACCOUNT_MANAGEMENT),
      ),
      body: Center(
        child: Column(
          children: [
            UserAvatar(
              user: user,
            ),
            Divider(),
            Expanded(
              child: loggedIn ? _loggedIn(user: user) : _loggedOut(),
            )
          ],
        ),
      ),
    );
  }
}
