import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class RecommendedCard extends StatelessWidget {
  final String? id;
  final String? image;
  final String? name;
  final String? track;
  final num? rating;
  final double? width;
  final double? imageHeight;
  final String? bio;
  final bool isLoading;

  const RecommendedCard({
    super.key,
    this.id,
    this.image,
    this.name,
    this.track,
    this.rating,
    this.width,
    this.imageHeight,
    this.bio,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = width ?? screenWidth * 0.45;
    final cardImageHeight = imageHeight ?? cardWidth * 0.55;

    if (isLoading) {
      return Container(
        width: cardWidth,
        height: cardImageHeight + 60,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: const Center(
          child: CircularProgressIndicator(
              color: AppPalette.primary, strokeWidth: 2),
        ),
      );
    }

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image أو placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: (image != null && image!.startsWith("http"))
                ? Image.network(
                    image!,
                    width: double.infinity,
                    height: cardImageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _buildPlaceholder(cardImageHeight),
                  )
                : _buildPlaceholder(cardImageHeight),
          ),

          SizedBox(height: screenWidth * 0.01),

          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.star, size: 16, color: Color(0xFFFFCE31)),
                    const SizedBox(width: 4),
                    Text(rating!.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Text(
                  track!,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade300,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
