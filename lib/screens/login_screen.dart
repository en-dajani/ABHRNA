import 'dart:io';
import 'package:abhrna/helpers/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:abhrna/providers/user_provider.dart';
import 'package:abhrna/routes/app_routes.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/widgets/app_text_form_field.dart';
import 'package:abhrna/widgets/buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  /// تسجيل الدخول بالبريد وكلمة المرور
  Future<void> _loginWithEmail(BuildContext context) async {
    final authProvider = context.read<UserProvider>();
    setState(() => _loading = true);

    try {
      await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!context.mounted) return;

      if (authProvider.isLoggedIn) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.splashScreen, (route) => false);
      }

      AppMessage.showSuccess(context, LocaleKeys.auth_success_login.tr());
    } catch (error) {
      if (!context.mounted) return;
      AppMessage.showError(context, error.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  /// تسجيل الدخول باستخدام Google
  Future<void> _loginWithGoogle(BuildContext context) async {
    final authProvider = context.read<UserProvider>();
    setState(() => _loading = true);

    try {
      final success = await authProvider.signInWithGoogle();

      if (!context.mounted) return;

      if (success) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.splashScreen, (route) => false);
      } else {
        AppMessage.showInfo(context, LocaleKeys.auth_login_cancelled.tr());
      }
    } catch (error) {
      if (!context.mounted) return;
      AppMessage.showError(context, error.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  /// تسجيل الدخول باستخدام Apple (معلق حالياً)
  Future<void> _loginWithApple() async {
    // يمكنك تفعيل تسجيل الدخول بـ Apple لاحقًا هنا
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.login.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // حقل البريد الإلكتروني
              AppTextFormField(
                controller: _emailController,
                label: LocaleKeys.email.tr(),
                validator:
                    ValidationBuilder(
                      localeName: context.locale.languageCode,
                    ).email().minLength(6).maxLength(50).build(),
              ),

              const SizedBox(height: 16),

              // حقل كلمة المرور
              AppTextFormField(
                controller: _passwordController,
                label: LocaleKeys.password.tr(),
                obscureText: true,
                validator:
                    ValidationBuilder(
                      localeName: context.locale.languageCode,
                    ).minLength(6).build(),
              ),

              const SizedBox(height: 24),

              // زر تسجيل الدخول بالبريد
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : AppFiledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _loginWithEmail(context);
                      }
                    },
                    child: Text(LocaleKeys.login.tr()),
                  ),

              const SizedBox(height: 16),

              Center(child: Text(LocaleKeys.or.tr())),

              const SizedBox(height: 16),

              // زر تسجيل الدخول بـ Google
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Google'),
                onPressed: _loading ? null : () => _loginWithGoogle(context),
              ),

              // زر تسجيل الدخول بـ Apple (فقط في iOS)
              if (Platform.isIOS)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.apple),
                    label: const Text('Apple'),
                    onPressed: _loading ? null : _loginWithApple,
                  ),
                ),

              const SizedBox(height: 24),

              // رابط التسجيل
              TextButton(
                onPressed:
                    _loading
                        ? null
                        : () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.registerScreen,
                          );
                        },
                child: Text(
                  '${LocaleKeys.no_account.tr()} ${LocaleKeys.register.tr()}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
