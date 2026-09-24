import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/priority.dart';
import '../models/category.dart';

/// Modal bottom sheet dialog for creating a new task or editing an existing task.
class AddEditTaskBottomSheet extends StatefulWidget {
  final Task? taskToEdit;
  final Function(Task task) onSave;

  const AddEditTaskBottomSheet({
    super.key,
    this.taskToEdit,
    required this.onSave,
  });

  @override
  State<AddEditTaskBottomSheet> createState() => _AddEditTaskBottomSheetState();
}

class _AddEditTaskBottomSheetState extends State<AddEditTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  late TaskCategory _selectedCategory;
  DateTime? _selectedDueDate;

  bool get _isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskToEdit?.title ?? '');
    _descriptionController = TextEditingController(text: widget.taskToEdit?.description ?? '');
    _selectedPriority = widget.taskToEdit?.priority ?? TaskPriority.medium;
    _selectedCategory = widget.taskToEdit?.category ?? TaskCategory.personal;
    _selectedDueDate = widget.taskToEdit?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Opens the Flutter date picker dialog.
  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  /// Validates input and triggers save callback.
  void _submitForm() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Task title cannot be empty!'),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final task = Task(
      id: _isEditing ? widget.taskToEdit!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: _descriptionController.text.trim(),
      isCompleted: _isEditing ? widget.taskToEdit!.isCompleted : false,
      priority: _selectedPriority,
      category: _selectedCategory,
      createdDate: _isEditing ? widget.taskToEdit!.createdDate : DateTime.now(),
      dueDate: _selectedDueDate,
    );

    widget.onSave(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: bottomPadding + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Handle Drag Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Edit Task ✏️' : 'New Task ✨',
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Task Title TextField
              TextFormField(
                controller: _titleController,
                autofocus: !_isEditing,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Task Title *',
                  hintText: 'What needs to be done?',
                  prefixIcon: const Icon(Icons.task_alt_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              // Task Description TextField
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add details or context...',
                  prefixIcon: const Icon(Icons.notes_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              // Priority Selector
              Text('Priority', style: theme.textTheme.titleMedium?.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: TaskPriority.values.map((priority) {
                  final isSelected = _selectedPriority == priority;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPriority = priority),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? priority.color
                                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? priority.color : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                priority.icon,
                                size: 16,
                                color: isSelected ? Colors.white : priority.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                priority.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : priority.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Category Selector
              Text('Category', style: theme.textTheme.titleMedium?.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TaskCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    avatar: Icon(cat.icon, size: 16, color: isSelected ? Colors.white : cat.color),
                    label: Text(cat.displayName),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: cat.color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Due Date Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDueDate == null
                            ? 'No due date set'
                            : 'Due: ${DateFormat('EEE, MMM d').format(_selectedDueDate!)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: _pickDueDate,
                    icon: Icon(_selectedDueDate == null ? Icons.add : Icons.edit, size: 16),
                    label: Text(_selectedDueDate == null ? 'Set Date' : 'Change'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(_isEditing ? Icons.save_rounded : Icons.add_rounded),
                  label: Text(_isEditing ? 'Save Changes' : 'Create Task'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
