import 'package:flutter/material.dart';
import '../models/priority.dart';

/// Small visual badge tag representing task priority level.
class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool isSelected;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: priority.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priority.color.withOpacity(isSelected ? 0.8 : 0.3),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority.icon,
            size: 12,
            color: priority.color,
          ),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: priority.color,
            ),
          ),
        ],
      ),
    );
  }
}
