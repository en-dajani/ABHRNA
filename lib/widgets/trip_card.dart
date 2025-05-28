import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String title;
  final String date;
  final String type;
  final IconData icon;
  final VoidCallback onTap;

  const TripCard({
    super.key,
    required this.title,
    required this.date,
    required this.type,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.secondaryHeaderColor,
                borderRadius: BorderRadius.horizontal(
                  left: isRTL ? Radius.circular(0) : Radius.circular(16),
                  right: isRTL ? Radius.circular(16) : Radius.circular(0),
                ),
              ),
              child: Icon(icon, size: 40, color: theme.colorScheme.primary),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(date, style: theme.textTheme.bodySmall),
                          const SizedBox(width: 8),
                          Chip(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            label: Text(
                              type,
                              style: const TextStyle(fontSize: 12),
                            ),
                            // backgroundColor: theme.colorScheme.secondaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
