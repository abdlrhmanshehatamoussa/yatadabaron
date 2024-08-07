import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MushafVerseListItem extends StatelessWidget {
  final String? text;
  final int? verseID;
  final double textSize;
  final double idSize;
  final Color? color;

  MushafVerseListItem({
    this.text,
    this.verseID,
    this.color,
    this.textSize = 20,
    this.idSize = 28,
  });
  @override
  Widget build(BuildContext context) {
    String verseIdStr = ArabicNumbersService.insance.convert(this.verseID);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$text $verseIdStr",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: this.idSize,
              fontFamily: "Usmani",
              color: this.color,
            ),
          ),
        ],
      ),
    );
  }
}
