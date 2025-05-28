import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/widgets/boats_tab.dart';
import 'package:abhrna/widgets/dashboard_header.dart';
import 'package:abhrna/widgets/trips_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _initialTabIndex = 0; // 👈 لحفظ آخر تبويب

  @override
  void initState() {
    super.initState();

    // نقرأ آخر تبويب محفوظ من PageStorage
    _initialTabIndex =
        PageStorage.of(context).readState(context, identifier: 'tab_index') ??
        0;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _initialTabIndex,
    );

    // نحفظ التبويب الحالي في كل تغيير
    _tabController.addListener(() {
      PageStorage.of(
        context,
      ).writeState(context, _tabController.index, identifier: 'tab_index');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DashboardHeader(),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          key: const PageStorageKey('dashboard_tab_bar'),
          indicatorSize: TabBarIndicatorSize.label,

          tabs: [
            Tab(
              // icon: Icon(Icons.directions_boat_filled),
              text: LocaleKeys.boats.tr(),
            ),
            Tab(
              // icon: Icon(Icons.schedule),
              text: LocaleKeys.scheduled_trips.tr(),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        key: const PageStorageKey('dashboard_tab_bar_view'),
        children: [BoatsTab(), TripsTab()],
      ),
    );
  }
}
