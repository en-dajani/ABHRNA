import 'package:abhrna/routes/app_routes.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/widgets/buttons.dart';
import 'package:abhrna/widgets/logo.dart';
import 'package:abhrna/widgets/toggle_language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcATop,
                  ),
                  child: Lottie.asset('assets/lottie/wave.json'),
                ),
              ),

              Logo(),

              Text(
                LocaleKeys.welcome_to.tr(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              AppFiledButton(
                child: Text(LocaleKeys.login.tr()),
                onPressed: () {
                  // Navigate to another screen or show more information
                  Navigator.pushNamed(context, AppRoutes.loginScreen);
                },
              ),

              SizedBox(height: 10),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48), // Full width button
                ),
                child: Text(LocaleKeys.signup.tr()),
                onPressed: () {
                  // Navigate to another screen or show more information
                  Navigator.pushNamed(context, AppRoutes.registerScreen);
                },
              ),
              const SizedBox(height: 10),
              ToggleLanguage(),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
