import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.notifications.tr())),
      body: ListView.separated(
        key: const PageStorageKey<String>('notification'),
        separatorBuilder:
            (context, index) => Divider(color: Colors.grey.withAlpha(30)),

        itemCount: 30,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Badge(isLabelVisible: true, child: Icon(LucideIcons.bell)),
            ),
            contentPadding: EdgeInsets.all(10),
            title: Text('data'),
            subtitle: Text('data'),
            onTap: () async {},
          );
        },
      ),
    );
  }
}
