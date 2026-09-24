import 'priority.dart';
import 'category.dart';

/// Representation of a single task in the application.
class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime createdDate;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    required this.createdDate,
    this.dueDate,
  });

  /// Creates a modified copy of the Task object.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? createdDate,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  /// Converts Task object into a JSON-compatible Map for SharedPreferences storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'category': category.index,
      'createdDate': createdDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  /// Factory constructor to reconstruct a Task object from JSON Map.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: TaskPriority.values[json['priority'] as int? ?? 1],
      category: TaskCategory.values[json['category'] as int? ?? 0],
      createdDate: DateTime.parse(json['createdDate'] as String),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
    );
  }
}
