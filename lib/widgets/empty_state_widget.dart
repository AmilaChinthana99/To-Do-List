import 'package:flutter/material.dart';

/// Clean empty state placeholder shown when no tasks exist or match search/filter.
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAddNewTask;

  const EmptyStateWidget({
    super.key,
    this.title = 'All clear for now!',
    this.message = 'You have no pending tasks. Tap "+" below to create a new task.',
    this.icon = Icons.check_circle_outline_rounded,
    this.onAddNewTask,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative background circle container
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(isDark ? 0.15 : 0.08),
              ),
              child: Icon(
                icon,
                size: 72,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAddNewTask != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAddNewTask,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add New Task'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
