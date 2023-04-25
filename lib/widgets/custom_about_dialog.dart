import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAboutDialog {

  final Uri _url = Uri.parse('https://www.buymeacoffee.com/thpir');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  AlertDialog getDialog(BuildContext context) {
    return AlertDialog(
      title: Text('about_title'.i18n()),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('about_text_1'.i18n()),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Text('about_text_2'.i18n()),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Text('about_text_3'.i18n()),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/thpir_logo.png',
                ),
              ),
            )
          ]
        ),
      ),
      actions: <Widget>[
        TextButton.icon(
          onPressed: () {
            _launchUrl();
            Navigator.of(context).pop();
          },
          label: Text(
            'button_text_buy_coffee'.i18n(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          icon: Icon(
            Icons.coffee_sharp,
            color: Theme.of(context).focusColor,
          )
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: Text(
            'button_text_close'.i18n(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          icon: Icon(
            Icons.close,
            color: Theme.of(context).focusColor,
          )
        ),
      ],
    );
  } 
}