import 'package:flutter/material.dart';
import '../models/category.dart';

/// Pill chip widget representing task categories with custom icon and colors.
class CategoryBadge extends StatelessWidget {
  final TaskCategory category;
  final bool compact;

  const CategoryBadge({
    super.key,
    required this.category,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: category.color.withOpacity(isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category.icon,
            size: compact ? 12 : 14,
            color: category.color,
          ),
          const SizedBox(width: 4),
          Text(
            category.displayName,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}
