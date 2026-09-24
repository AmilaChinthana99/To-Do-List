import 'package:flutter/material.dart';
import '../models/category.dart';

enum FilterStatus { all, active, completed }

/// Interactive search and category filter bar.
class FilterChipBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final FilterStatus selectedStatus;
  final ValueChanged<FilterStatus> onStatusChanged;
  final TaskCategory? selectedCategory;
  final ValueChanged<TaskCategory?> onCategoryChanged;

  const FilterChipBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Real-time Search Field
        TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () => onSearchChanged(''),
                  )
                : null,
            filled: true,
            fillColor: theme.cardTheme.color,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Status Segmented Controls (All / Active / Completed)
        Row(
          children: FilterStatus.values.map((status) {
            final isSelected = selectedStatus == status;
            String label;
            switch (status) {
              case FilterStatus.all:
                label = 'All';
                break;
              case FilterStatus.active:
                label = 'Active';
                break;
              case FilterStatus.completed:
                label = 'Completed';
                break;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onStatusChanged(status);
                  },
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.cardTheme.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  showCheckmark: false,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),

        // Horizontal Category Filter Chips
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: const Text('All Categories'),
                  selected: selectedCategory == null,
                  onSelected: (_) => onCategoryChanged(null),
                  selectedColor: theme.colorScheme.primary.withOpacity(0.15),
                  checkmarkColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              ...TaskCategory.values.map((cat) {
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    avatar: Icon(cat.icon, size: 14, color: cat.color),
                    label: Text(cat.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      onCategoryChanged(selected ? cat : null);
                    },
                    selectedColor: cat.color.withOpacity(0.2),
                    checkmarkColor: cat.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
