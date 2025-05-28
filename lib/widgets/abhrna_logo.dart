import 'package:flutter/material.dart';

class AbhrnaLogo extends StatelessWidget {
  const AbhrnaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 200,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
