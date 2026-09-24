import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../services/storage_service.dart';
import '../widgets/task_summary_card.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/add_edit_task_bottom_sheet.dart';

/// Main screen managing application state (setState) and task operations.
class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  // Filter & Search Controls
  String _searchQuery = '';
  FilterStatus _selectedStatus = FilterStatus.all;
  TaskCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadInitialTasks();
  }

  /// Loads persisted tasks from local SharedPreferences storage.
  Future<void> _loadInitialTasks() async {
    setState(() => _isLoading = true);
    final loaded = await StorageService.loadTasks();
    setState(() {
      _tasks = loaded;
      _isLoading = false;
    });
  }

  /// Saves updated task list state to SharedPreferences.
  Future<void> _persistTasks() async {
    await StorageService.saveTasks(_tasks);
  }

  /// Adds a new task to the list and updates persistent storage.
  void _addTask(Task task) {
    setState(() {
      _tasks.insert(0, task);
    });
    _persistTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Task added successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Updates an existing task details.
  void _updateTask(Task updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    });
    _persistTasks();
  }

  /// Toggles completion status of a task.
  void _toggleTaskCompletion(String taskId, bool isCompleted) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
      }
    });
    _persistTasks();
  }

  /// Deletes a task from the list with an Undo option in SnackBar.
  void _deleteTask(String taskId) {
    final deletedTaskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (deletedTaskIndex == -1) return;

    final deletedTask = _tasks[deletedTaskIndex];

    setState(() {
      _tasks.removeAt(deletedTaskIndex);
    });
    _persistTasks();

    // Show Undo SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${deletedTask.title}"'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amberAccent,
          onPressed: () {
            setState(() {
              _tasks.insert(deletedTaskIndex, deletedTask);
            });
            _persistTasks();
          },
        ),
      ),
    );
  }

  /// Removes all completed tasks.
  void _clearCompletedTasks() {
    final completedCount = _tasks.where((t) => t.isCompleted).length;
    if (completedCount == 0) return;

    setState(() {
      _tasks.removeWhere((t) => t.isCompleted);
    });
    _persistTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cleared $completedCount completed task(s)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Displays modal bottom sheet for creating or editing tasks.
  void _showAddEditBottomSheet([Task? taskToEdit]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => AddEditTaskBottomSheet(
        taskToEdit: taskToEdit,
        onSave: (task) {
          if (taskToEdit == null) {
            _addTask(task);
          } else {
            _updateTask(task);
          }
        },
      ),
    );
  }

  /// Computes the list of tasks matching current filter and search query.
  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      // 1. Status Filter
      if (_selectedStatus == FilterStatus.active && task.isCompleted) return false;
      if (_selectedStatus == FilterStatus.completed && !task.isCompleted) return false;

      // 2. Category Filter
      if (_selectedCategory != null && task.category != _selectedCategory) return false;

      // 3. Search Query Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDesc = task.description.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedCount = _tasks.where((t) => t.isCompleted).length;
    final totalCount = _tasks.length;
    final filtered = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'TaskFlow',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 6),
                Text('⚡', style: TextStyle(fontSize: 18)),
              ],
            ),
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()),
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          // Theme Switcher Button (Dark / Light)
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: widget.isDarkMode ? Colors.amber : theme.iconTheme.color,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () => widget.onToggleTheme(!widget.isDarkMode),
          ),
          // Popup Menu for Options
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (value) {
              if (value == 'clear_completed') {
                _clearCompletedTasks();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear_completed',
                enabled: completedCount > 0,
                child: const Row(
                  children: [
                    Icon(Icons.cleaning_services_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Clear Completed'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInitialTasks,
              child: CustomScrollView(
                slivers: [
                  // Top Summary Progress Header Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: TaskSummaryCard(
                        totalTasks: totalCount,
                        completedTasks: completedCount,
                      ),
                    ),
                  ),

                  // Search and Filter Chips Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FilterChipBar(
                        searchQuery: _searchQuery,
                        onSearchChanged: (val) => setState(() => _searchQuery = val),
                        selectedStatus: _selectedStatus,
                        onStatusChanged: (status) => setState(() => _selectedStatus = status),
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // Task List or Empty State
                  filtered.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyStateWidget(
                            title: _tasks.isEmpty
                                ? 'No tasks yet!'
                                : 'No matching tasks found',
                            message: _tasks.isEmpty
                                ? 'Tap the "+" button below to create your first task.'
                                : 'Try changing your search terms or filter selection.',
                            icon: _tasks.isEmpty
                                ? Icons.task_alt_rounded
                                : Icons.search_off_rounded,
                            onAddNewTask: _tasks.isEmpty ? () => _showAddEditBottomSheet() : null,
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final task = filtered[index];
                                return TaskCard(
                                  task: task,
                                  onToggleComplete: (isCompleted) =>
                                      _toggleTaskCompletion(task.id, isCompleted),
                                  onTap: () => _showAddEditBottomSheet(task),
                                  onDelete: () => _deleteTask(task.id),
                                );
                              },
                              childCount: filtered.length,
                            ),
                          ),
                        ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditBottomSheet(),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
