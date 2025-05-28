import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.width});
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/only_logo.png',
      width: width ?? 100,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
