import 'package:flutter/material.dart';

/// Defines task priority levels: Low, Medium, and High.
enum TaskPriority {
  low,
  medium,
  high,
}

/// Extension on TaskPriority providing UI attributes like colors, labels, and icons.
extension TaskPriorityExtension on TaskPriority {
  /// User-friendly title for the priority level.
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  /// Primary color badge associated with each priority level.
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFF10B981); // Emerald Green
      case TaskPriority.medium:
        return const Color(0xFFF59E0B); // Amber / Yellow
      case TaskPriority.high:
        return const Color(0xFFEF4444); // Crimson Red
    }
  }

  /// Subtle background tint for priority tags.
  Color get backgroundColor {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFFE6F4EA);
      case TaskPriority.medium:
        return const Color(0xFFFEF3C7);
      case TaskPriority.high:
        return const Color(0xFFFEE2E2);
    }
  }

  /// Icon representing the priority urgency.
  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward_rounded;
      case TaskPriority.medium:
        return Icons.remove_rounded;
      case TaskPriority.high:
        return Icons.priority_high_rounded;
    }
  }
}
