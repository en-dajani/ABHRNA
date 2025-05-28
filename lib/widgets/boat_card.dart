import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BoatCard extends StatelessWidget {
  final String name;
  final String city;
  final String image;
  final VoidCallback onTap;

  const BoatCard({
    super.key,
    required this.name,
    required this.city,
    required this.image,
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
              color: Colors.black.withAlpha(13), // بدلاً من withValues
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: isRTL ? Radius.circular(0) : Radius.circular(16),
                right: isRTL ? Radius.circular(16) : Radius.circular(0),
              ),
              child: CachedNetworkImage(
                imageUrl: image,
                width: 110,
                height: 100,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: theme.secondaryHeaderColor,
                      ),
                      width: 110,
                      height: 100,

                      // child: Image.asset(
                      //   'assets/images/only_logo.png', // غيرها لاحقًا حسب صورتك
                      //   opacity: const AlwaysStoppedAnimation(0.2),
                      // ),
                    ),
              ),
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
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(city, style: theme.textTheme.bodySmall),
                      ],
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
