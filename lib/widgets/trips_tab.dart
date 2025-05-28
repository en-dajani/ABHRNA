import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:abhrna/widgets/trip_card.dart';

class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => _TripsTabState();
}

class _TripsTabState extends State<TripsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final trips = [
      {
        'title': 'نزهة بحرية ممتعة',
        'date': '25 أبريل - 3:00 م',
        'type': 'نزهة',
        'icon': Icons.sailing,
      },
      {
        'title': 'صيد مع المحترفين',
        'date': '27 أبريل - 6:00 ص',
        'type': 'صيد',
        'icon': LucideIcons.fish,
      },
      {
        'title': 'غوص في الأعماق',
        'date': '29 أبريل - 9:00 ص',
        'type': 'غوص',
        'icon': Icons.scuba_diving,
      },
    ];

    return ListView.builder(
      key: const PageStorageKey('trips_list'),
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return TripCard(
          title: trip['title']! as String,
          date: trip['date']! as String,
          type: trip['type']! as String,
          icon: trip['icon'] as IconData,
          onTap: () {},
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
