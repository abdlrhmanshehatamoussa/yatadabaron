import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تواصل معنا"),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: ListView(
          children: [
            ListTile(
              title: (Text("تليجرام")),
              subtitle: Text("تواصل معنا عبر التليجرام"),
              trailing: Icon(
                Icons.telegram,
                color: Colors.lightBlue,
                size: 45,
              ),
              onTap: () async {
                await launchUrl(
                  Uri.parse("https://t.me/+4ynYuVL39TcxNDA0"),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              title: (Text("واتساب")),
              subtitle: Text("تواصل معنا عبر الواتساب"),
              trailing: Icon(
                Icons.call,
                color: Colors.green,
                size: 45,
              ),
              onTap: () async {
                await launchUrl(
                  Uri.parse("https://chat.whatsapp.com/IxM03aSHIHSAFgrfCMW9W8"),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
