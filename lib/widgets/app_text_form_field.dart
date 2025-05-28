import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.obscureText = false,
    this.label,
    this.validator,
    this.textInputAction,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final String? label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor: Colors.grey,
        hintText: label,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[100] // Light background color for light mode
            : Colors.grey[800], // Dark background color for dark mode
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
          borderSide: BorderSide.none, // No border
        ),
      ),
      validator: validator,
    );
  }
}
