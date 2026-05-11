import 'package:flutter/material.dart';

class TopUserCard extends StatelessWidget {
  final String? id;
  final String? image;
  final String? name;
  final String? track;
  final num? hours;
  final double? widthCard;
  final bool isLoading;

  const TopUserCard({
    super.key,
    this.widthCard,
    this.id,
    this.image,
    this.name,
    this.track,
    this.hours,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = widthCard ?? 180;

    if (isLoading) {
      return Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: cardWidth,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Avatar
          ClipOval(
            child: (image != null && image!.startsWith("http"))
                ? Image.network(
                    image!,
                    width: cardWidth * 0.25,
                    height: cardWidth * 0.25,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
                  )
                : _buildPlaceholder(cardWidth),
          ),

          SizedBox(height: cardWidth * 0.08),

          Text(
            name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          SizedBox(height: 4),

          Text(
            track ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),

          SizedBox(height: cardWidth * 0.06),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: cardWidth * 0.1,
              vertical: cardWidth * 0.03,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              "$hours",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(double cardWidth) {
    return Container(
      width: cardWidth * 0.25,
      height: cardWidth * 0.25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }
}
