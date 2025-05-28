import 'package:flutter/material.dart';

class AppFiledButton extends StatelessWidget {
  const AppFiledButton({super.key, this.onPressed, required this.child});
  final Widget? child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, 48), // Full width button
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
