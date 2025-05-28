import 'package:abhrna/providers/user_provider.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/widgets/location_summary_selector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final user = context.watch<UserProvider>().user;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocaleKeys.hello.tr()} ${user?.name} 👋',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),
          LocationSummarySelector(),
        ],
      ),
    );
  }
}
