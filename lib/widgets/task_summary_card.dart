import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Top header banner showing completed task summary, progress bar, and motivational feedback.
class TaskSummaryCard extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const TaskSummaryCard({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;
    final int percentage = (progress * 100).round();

    String getMotivationalQuote() {
      if (totalTasks == 0) return 'Add your first task to get started!';
      if (progress == 1.0) return 'All tasks finished! Awesome work 🎉';
      if (progress >= 0.7) return 'Almost there! Keep pushing 💪';
      if (progress >= 0.3) return 'Great start! Keep making progress 🔥';
      return 'Let\'s get things done today ✨';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Progress',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalTasks == 0
                        ? 'No active tasks'
                        : '$completedTasks of $totalTasks completed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Percentage Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Animated Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: progress),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            getMotivationalQuote(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
