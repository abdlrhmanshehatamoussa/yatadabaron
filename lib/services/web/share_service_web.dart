import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/main.dart';

class ShareServiceWeb extends IShareService {
  @override
  Future<void> share(String textToShare) async {
    await showDialog(
      context: appNavigator.context,
      builder: (_) => AlertDialog(
        title: SelectableText(textToShare),
      ),
    );
  }
}
