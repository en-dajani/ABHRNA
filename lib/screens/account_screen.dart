import 'package:abhrna/providers/user_provider.dart';
import 'package:abhrna/routes/app_routes.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/widgets/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authProvider = context.watch<UserProvider>();
    final user = authProvider.user;
    final hasBoat = authProvider.user?.hasBoat ?? false;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // 👤 صورة واسم وبريد
            Center(
              child: Column(
                children: [
                  UserAvatar(photoUrl: user?.photoUrl),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(user?.email ?? '', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // تعديل الحساب
                    },
                    child: Text(LocaleKeys.edit_profile.tr()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 🧾 الحساب - رحلات، طلبات، قاربي
            Text(
              LocaleKeys.account_section.tr(),
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 12),

            _tile(
              context,
              icon: Icons.list_alt,
              title: LocaleKeys.my_requests.tr(),
              onTap: () => Navigator.pushNamed(context, "/myRequests"),
            ),
            _tile(
              context,
              icon: Icons.calendar_month,
              title: LocaleKeys.my_scheduled_trips.tr(),
              onTap: () => Navigator.pushNamed(context, "/myScheduledTrips"),
            ),

            _tile(
              context,
              icon: Icons.directions_boat,
              title: hasBoat
                  ? LocaleKeys.my_boat.tr()
                  : LocaleKeys.register_boat.tr(),
              onTap: () {
                if (hasBoat) {
                  Navigator.pushNamed(context, "/myBoat");
                } else {
                  Navigator.pushNamed(context, AppRoutes.boatFormScreen);
                }
              },
            ),
            const SizedBox(height: 24),

            // ⚙️ التفضيلات
            Text(
              LocaleKeys.preferences.tr(),
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 12),
            _tile(
              context,
              icon: Icons.language,
              title: context.locale.languageCode == 'ar'
                  ? LocaleKeys.english.tr()
                  : LocaleKeys.arabic.tr(),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        LocaleKeys.language_change.tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                      content: Text(
                        context.locale.languageCode == 'ar'
                            ? LocaleKeys.english.tr()
                            : LocaleKeys.arabic.tr(),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        FilledButton(
                          onPressed: () {
                            context.setLocale(
                              context.locale.languageCode == 'ar'
                                  ? const Locale('en')
                                  : const Locale('ar'),
                            );
                            Navigator.pop(context);
                          },
                          child: Text(LocaleKeys.confirm.tr()),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(LocaleKeys.cancel.tr()),
                        ),
                      ],
                    );
                  },
                );
                // تغيير اللغة
              },
            ),
            _switchTile(
              context,
              icon: Icons.notifications,
              title: LocaleKeys.push_notifications.tr(),
              value: true,
              onChanged: (val) {},
            ),
            _switchTile(
              context,
              icon: Icons.brightness_6,
              title: LocaleKeys.theme.tr(),
              value: isDark,
              onChanged: (val) {
                // toggleTheme
              },
            ),

            const SizedBox(height: 24),

            // 🚪 تسجيل الخروج
            _tile(
              context,
              icon: Icons.logout,
              title: LocaleKeys.logout.tr(),
              iconColor: Colors.red,
              textColor: Colors.red,

              onTap: () async {
                // write a dialog to confirm logout
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        LocaleKeys.logout.tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                      // content: Text(LocaleKeys.logout.tr()),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        FilledButton(
                          onPressed: () async {
                            await authProvider.signOut();

                            if (!context.mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.splashScreen,
                              (route) => false,
                            );
                          },
                          child: Text(LocaleKeys.confirm.tr()),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(LocaleKeys.cancel.tr()),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withAlpha(13)),
      ),
      leading: Icon(icon, color: iconColor ?? theme.iconTheme.color),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withAlpha(20)),
      ),
      leading: Icon(icon),
      title: Text(title, style: theme.textTheme.bodyMedium),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
