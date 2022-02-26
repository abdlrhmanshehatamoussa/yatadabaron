import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';

class UserAvatar extends StatelessWidget {
  final User? user;
  const UserAvatar({
    Key? key,
    required this.user,
  }) : super(key: key);

  Widget _offlineIcon() {
    return Icon(
      Icons.account_circle,
      size: 35,
    );
  }

  Widget _online(User user) {
    return ListTile(
      title: SingleChildScrollView(
        child: Text(user.displayName),
        scrollDirection: Axis.horizontal,
      ),
      subtitle: SingleChildScrollView(
        child: Text(user.email),
        scrollDirection: Axis.horizontal,
      ),
      contentPadding: EdgeInsets.all(5),
      leading: CachedNetworkImage(
        imageUrl: user.imageURL,
        height: 50,
        placeholder: (context, url) => _offlineIcon(),
        errorWidget: (___, __, _) => _offlineIcon(),
        imageBuilder: (context, image) => CircleAvatar(
          backgroundImage: image,
          radius: 30,
        ),
      ),
    );
  }

  Widget _offline() {
    return ListTile(
      title: Text("${Localization.WELCOME} - ${Localization.GUEST}"),
      subtitle: Text(Localization.CLICK_TO_SIGN_IN),
      leading: _offlineIcon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return _online(user!);
    } else {
      return _offline();
    }
  }
}
