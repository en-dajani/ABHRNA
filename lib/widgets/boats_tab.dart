import 'package:abhrna/providers/boat_provider.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:abhrna/widgets/boat_card.dart';
import 'package:provider/provider.dart';

class BoatsTab extends StatefulWidget {
  const BoatsTab({super.key});

  @override
  State<BoatsTab> createState() => _BoatsTabState();
}

class _BoatsTabState extends State<BoatsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    final boats = context.watch<BoatProvider>().items;
    final isLoading = context.watch<BoatProvider>().isLoading;

    if (isLoading && boats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (boats.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_boat,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(LocaleKeys.no_boats_available).tr(),
          ],
        ),
      );
    }

    return ListView.builder(
      key: const PageStorageKey('boats_list'),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: boats.length,
      itemBuilder: (context, index) {
        final boat = boats[index];
        return BoatCard(
          name: boat.name,
          city: boat.address?.city.name['ar'] ?? '',
          image: boat.images.first,
          onTap: () {},
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
