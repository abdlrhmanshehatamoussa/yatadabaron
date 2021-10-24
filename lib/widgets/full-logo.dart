import 'package:flutter/cupertino.dart';
import 'logo-transparent.dart';

class FullLogo extends StatelessWidget {
  final double padding;
  final String versionLabel;

  const FullLogo({
    this.padding = 0,
    required this.versionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(this.padding),
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('assets/imgs/home.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: LogoTansparent(
        versionLabel: versionLabel,
      ),
    );
  }
}
