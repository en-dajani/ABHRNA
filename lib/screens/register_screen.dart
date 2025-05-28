import 'package:abhrna/helpers/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:form_validator/form_validator.dart';

import 'package:abhrna/widgets/app_text_form_field.dart';
import 'package:abhrna/providers/user_provider.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  /// دالة إنشاء حساب جديد
  Future<void> _register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<UserProvider>();
    setState(() => _loading = true);

    try {
      // تنفيذ عملية التسجيل
      await authProvider.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.splashScreen, (route) => false);

      AppMessage.showSuccess(context, LocaleKeys.auth_success_login.tr());
    } catch (e) {
      if (!context.mounted) return;

      // عرض رسالة الخطأ
      AppMessage.showError(context, e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.create_account.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // حقل البريد الإلكتروني
              AppTextFormField(
                controller: _emailController,
                label: LocaleKeys.email.tr(),
                validator:
                    ValidationBuilder(
                      localeName: context.locale.languageCode,
                    ).email().minLength(6).maxLength(50).build(),
              ),

              const SizedBox(height: 12),

              // حقل كلمة المرور
              AppTextFormField(
                controller: _passwordController,
                obscureText: true,
                label: LocaleKeys.password.tr(),
                validator:
                    ValidationBuilder(
                      localeName: context.locale.languageCode,
                    ).minLength(6).build(),
              ),

              const SizedBox(height: 24),

              // زر إنشاء الحساب أو مؤشر تحميل
              _loading
                  ? const CircularProgressIndicator()
                  : FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => _register(context),
                    child: Text(LocaleKeys.register.tr()),
                  ),

              const SizedBox(height: 24),

              // رابط تسجيل الدخول للمستخدمين المسجلين مسبقًا
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.loginScreen,
                  );
                },
                child: Text(
                  '${LocaleKeys.have_account.tr()} ${LocaleKeys.login.tr()}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
