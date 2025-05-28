import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ToggleLanguage extends StatelessWidget {
  const ToggleLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        context.setLocale(
          'ar' == context.locale.languageCode
              ? const Locale('en')
              : const Locale('ar'),
        );
      },
      icon: Icon(Icons.language),
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, 48), // Full width button
      ),
      iconAlignment: IconAlignment.end,
      label: Text(context.locale.languageCode == 'ar' ? 'English' : 'عربي'),
    );
  }
}
