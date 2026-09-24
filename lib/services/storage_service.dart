import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/priority.dart';
import '../models/category.dart';

/// Handles local data storage and retrieval using SharedPreferences.
class StorageService {
  static const String _tasksKey = 'user_tasks_list';

  /// Saves the current list of tasks to SharedPreferences as a JSON string.
  static Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = tasks.map((task) => task.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);
      return await prefs.setString(_tasksKey, jsonString);
    } catch (e) {
      print('Error saving tasks to SharedPreferences: $e');
      return false;
    }
  }

  /// Loads stored tasks from SharedPreferences. Returns default initial tasks if empty.
  static Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_tasksKey);

      if (jsonString == null || jsonString.isEmpty) {
        // Return friendly default starter tasks on first app load
        final defaultTasks = _getInitialDefaultTasks();
        await saveTasks(defaultTasks);
        return defaultTasks;
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Task.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading tasks from SharedPreferences: $e');
      return _getInitialDefaultTasks();
    }
  }

  /// Generates a set of helpful starter tasks for first-time users.
  static List<Task> _getInitialDefaultTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: 'default_1',
        title: 'Explore TaskFlow To-Do App 🚀',
        description: 'Try tapping tasks to edit, or swiping left/right to delete!',
        isCompleted: false,
        priority: TaskPriority.high,
        category: TaskCategory.personal,
        createdDate: now,
        dueDate: now.add(const Duration(days: 1)),
      ),
      Task(
        id: 'default_2',
        title: 'Design UI mockup in Figma 🎨',
        description: 'Create responsive component wireframes for project dashboard.',
        isCompleted: true,
        priority: TaskPriority.medium,
        category: TaskCategory.work,
        createdDate: now.subtract(const Duration(hours: 4)),
      ),
      Task(
        id: 'default_3',
        title: 'Buy fresh groceries & fruit 🛒',
        description: 'Apples, almond milk, sourdough bread, and coffee beans.',
        isCompleted: false,
        priority: TaskPriority.low,
        category: TaskCategory.shopping,
        createdDate: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
