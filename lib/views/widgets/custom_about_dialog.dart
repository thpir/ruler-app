import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAboutDialog {
  

  AlertDialog getDialog(BuildContext context) {
    final Uri uri = Uri.parse('https://www.buymeacoffee.com/thpir');

    Future<void> navigateToWeb() async {
      try {
        await launchUrl(uri);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString(), style: const TextStyle(color: Colors.white),),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'about_title'.i18n(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
        ]),
      ),
      actions: <Widget>[
        TextButton.icon(
            onPressed: () {
              navigateToWeb();
              Navigator.of(context).pop();
            },
            label: Text(
              'button_text_buy_coffee'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            icon: Icon(
              Icons.coffee_sharp,
              color: Theme.of(context).focusColor,
            )),
        TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            label: Text(
              'button_text_close'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).focusColor,
            )),
      ],
    );
  }
}
