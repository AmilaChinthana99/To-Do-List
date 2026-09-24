import 'package:flutter/material.dart';

/// Categories for organizing tasks into logical groups.
enum TaskCategory {
  personal,
  work,
  shopping,
  health,
  education,
  other,
}

/// Extension providing display titles, icons, and colors for task categories.
extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.education:
        return 'Education';
      case TaskCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.personal:
        return Icons.person_outline_rounded;
      case TaskCategory.work:
        return Icons.work_outline_rounded;
      case TaskCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TaskCategory.health:
        return Icons.favorite_border_rounded;
      case TaskCategory.education:
        return Icons.school_outlined;
      case TaskCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.personal:
        return const Color(0xFF6366F1); // Indigo
      case TaskCategory.work:
        return const Color(0xFF0EA5E9); // Sky Blue
      case TaskCategory.shopping:
        return const Color(0xFFEC4899); // Pink
      case TaskCategory.health:
        return const Color(0xFF10B981); // Emerald
      case TaskCategory.education:
        return const Color(0xFF8B5CF6); // Purple
      case TaskCategory.other:
        return const Color(0xFF64748B); // Slate
    }
  }
}
