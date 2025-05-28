import 'package:abhrna/providers/boat_provider.dart';
import 'package:abhrna/screens/account_screen.dart';
import 'package:abhrna/screens/dashboard_screen.dart';
import 'package:abhrna/screens/notification_screen.dart';
import 'package:abhrna/services/user_preferences.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? selectedCityId;

  final List<Widget> _screens = [
    DashboardScreen(),
    NotificationScreen(),
    Center(child: Text(LocaleKeys.my_trips.tr())),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final (country, city) = await UserPreferences.loadLocationModels();

      if (country != null) {
        context.read<BoatProvider>().loadInitial(
          filters: {
            'address.country.id': country.id,
            if (city != null) 'address.city.id': city.id,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withAlpha(240),
          // borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            // height: 56,
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
              final isSelected = states.contains(WidgetState.selected);
              return IconThemeData(
                color:
                    isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withAlpha(130),
                size: 24,
              );
            }),
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 10),
            ),
            indicatorColor: colorScheme.primary.withAlpha(30),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(LucideIcons.house),
                label: LocaleKeys.home.tr(),
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('3'),

                  isLabelVisible: true,
                  child: Icon(LucideIcons.bell),
                ),
                label: LocaleKeys.notifications.tr(),
              ),
              NavigationDestination(
                icon: Icon(LucideIcons.calendar),
                label: LocaleKeys.my_trips.tr(),
              ),
              NavigationDestination(
                icon: Icon(LucideIcons.user),
                label: LocaleKeys.account.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
