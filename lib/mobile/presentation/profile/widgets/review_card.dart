import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final String name;
  final String review;
  final num rating;
  final String image;
  final String role;
  final DateTime time;

  const ReviewCard({
    super.key,
    required this.name,
    required this.review,
    required this.rating,
    required this.image,
    required this.role,
    required this.time,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  String formatTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final diff = dateTime.difference(now);

    if (diff.isNegative) {
      final pastDiff = now.difference(dateTime);
      if (pastDiff.inDays > 0) return "${pastDiff.inDays}d ago";
      if (pastDiff.inHours > 0) return "${pastDiff.inHours}h ago";
      if (pastDiff.inMinutes > 0) return "${pastDiff.inMinutes}m ago";
      return "${pastDiff.inSeconds}s ago";
    } else {
      if (diff.inDays > 0) return "in ${diff.inDays}d";
      if (diff.inHours > 0)
        return "in ${diff.inHours}h ${diff.inMinutes % 60}m";
      if (diff.inMinutes > 0) return "in ${diff.inMinutes}m";
      return "in ${diff.inSeconds}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.35;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: widget.image.startsWith("http")
                    ? Image.network(
                        widget.image,
                        width: cardWidth * 0.25,
                        height: cardWidth * 0.25,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildPlaceholder(cardWidth),
                      )
                    : _buildPlaceholder(cardWidth),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.name ?? "user"} (${widget.role ?? "Normal"})",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      children: List.generate(
                        widget.rating.toInt(),
                        (i) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.review,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleSmall!.color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                formatTimeDifference(widget.time),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey),
              ),
            ],
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
      child: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
