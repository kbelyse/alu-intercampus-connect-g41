// Full-screen create post with Event/Opportunity toggle, form fields, and validation.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  bool _isEvent = true;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  DateTime? _selectedDate;
  String _campus = 'Kigali';
  String _category = 'Workshop';
  String _visibility = 'Everyone';
  final List<String> _tags = [];
  final _tagController = TextEditingController();
  int? _selectedCover;

  static const _mockCovers = [
    Color(0xFF6C63FF),
    Color(0xFFF5A623),
    Color(0xFF2ECC71),
    Color(0xFF3BAFDA),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _maxParticipantsController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.elevated,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _addTag(String value) {
    final tag = value.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() => _tags.add(tag));
    }
    _tagController.clear();
  }

  void _publish() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${_isEvent ? 'Event' : 'Opportunity'} published successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(LucideIcons.x,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Create',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // Type toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Row(
                  children: [
                    _ToggleButton(
                      label: 'Event',
                      isSelected: _isEvent,
                      onTap: () => setState(() => _isEvent = true),
                    ),
                    _ToggleButton(
                      label: 'Opportunity',
                      isSelected: !_isEvent,
                      onTap: () => setState(() => _isEvent = false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Cover picker
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.elevated,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.bottomSheet),
                      ),
                    ),
                    builder: (_) => _CoverPicker(
                      covers: _mockCovers,
                      selected: _selectedCover,
                      onSelect: (i) {
                        setState(() => _selectedCover = i);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: _selectedCover != null
                        ? _mockCovers[_selectedCover!].withOpacity(0.3)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(
                      color: AppColors.border,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _selectedCover != null
                      ? Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _mockCovers[_selectedCover!].withOpacity(0.8),
                                AppColors.background,
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(AppRadius.card),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(LucideIcons.check,
                              color: Colors.white, size: 32),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(LucideIcons.camera,
                                color: AppColors.textSecondary, size: 32),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Add cover photo',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              _buildLabel('Title *'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                    hintText: 'Give it a clear, compelling name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Title is required'
                        : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Description
              _buildLabel('Description *'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descController,
                style: const TextStyle(color: AppColors.textPrimary),
                maxLines: 4,
                decoration: const InputDecoration(
                    hintText:
                        'What should attendees know?'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Description is required'
                        : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Date & Time
              _buildLabel('Date & Time *'),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppRadius.button),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.calendar,
                          color: AppColors.textSecondary,
                          size: AppIconSize.inline),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        _selectedDate != null
                            ? DateFormat('MMM d, yyyy').format(_selectedDate!)
                            : 'Select date and time',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Campus dropdown
              _buildLabel('Campus *'),
              const SizedBox(height: AppSpacing.sm),
              _buildDropdown(
                value: _campus,
                items: kCampuses,
                onChanged: (v) => setState(() => _campus = v!),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category dropdown
              _buildLabel('Category *'),
              const SizedBox(height: AppSpacing.sm),
              _buildDropdown(
                value: _category,
                items: kCategories,
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Max Participants
              _buildLabel('Max Participants (optional)'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _maxParticipantsController,
                style: const TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                    hintText: 'Leave blank for unlimited'),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tags
              _buildLabel('Tags'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                          hintText: 'Type a tag and press Add'),
                      onSubmitted: _addTag,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: () => _addTag(_tagController.text),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppRadius.button),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _tags
                      .map(
                        (t) => Chip(
                          label: Text('#$t'),
                          onDeleted: () =>
                              setState(() => _tags.remove(t)),
                          deleteIconColor: AppColors.textSecondary,
                          backgroundColor: AppColors.neutralTag,
                          labelStyle: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                          side: BorderSide.none,
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),

              // Visibility toggle
              _buildLabel('Who can see this?'),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Row(
                  children: [
                    _ToggleButton(
                      label: 'Everyone',
                      isSelected: _visibility == 'Everyone',
                      onTap: () =>
                          setState(() => _visibility = 'Everyone'),
                    ),
                    _ToggleButton(
                      label: 'My Communities',
                      isSelected: _visibility == 'My Communities',
                      onTap: () =>
                          setState(() => _visibility = 'My Communities'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Publish button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _publish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.button),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Publish',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.elevated,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          icon: const Icon(LucideIcons.chevronDown,
              color: AppColors.textSecondary, size: 16),
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDuration.fast,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : AppColors.textSecondary,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverPicker extends StatelessWidget {
  final List<Color> covers;
  final int? selected;
  final ValueChanged<int> onSelect;

  const _CoverPicker({
    required this.covers,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose a cover',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: covers
                .asMap()
                .entries
                .map(
                  (e) => GestureDetector(
                    onTap: () => onSelect(e.key),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [e.value, AppColors.background],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: selected == e.key
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: selected == e.key
                          ? const Icon(LucideIcons.check,
                              color: Colors.white)
                          : null,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
