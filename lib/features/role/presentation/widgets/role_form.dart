import 'package:flutter/material.dart';

class RoleForm extends StatefulWidget {
  const RoleForm({
    super.key,
    this.initialRoleName = '',
    this.initialDescription = '',
    this.initialIsActive = true,
    this.isLoading = false,
    required this.onSubmit,
  });

  // =============================================================
  // INITIAL VALUES
  // =============================================================

  final String initialRoleName;

  final String initialDescription;

  final bool initialIsActive;

  final bool isLoading;

  // =============================================================
  // SUBMIT
  // =============================================================
  //
  // IMPORTANT:
  //
  // companyId এখানে নেই।
  // roleCode এখানেও নেই।
  //
  // companyId:
  //     CurrentUser.companyId
  //
  // createdBy:
  //     CurrentUser.userId
  //
  // updatedBy:
  //     CurrentUser.userId
  //
  // =============================================================

  final Future<void> Function(
      String roleName,
      String description,
      bool isActive,
      ) onSubmit;

  @override
  State<RoleForm> createState() => _RoleFormState();
}

class _RoleFormState extends State<RoleForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _roleNameController;

  late TextEditingController _descriptionController;

  late bool _isActive;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _roleNameController = TextEditingController(
      text: widget.initialRoleName,
    );

    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );

    _isActive = widget.initialIsActive;
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _roleNameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final roleName = _roleNameController.text.trim();

    final description = _descriptionController.text.trim();

    await widget.onSubmit(
      roleName,
      description,
      _isActive,
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isSmall = width < 360;
        final isCompact = width < 500;
        final isWide = width >= 700;

        final fieldSpacing = isSmall ? 13.0 : 16.0;

        final buttonHeight = isSmall ? 46.0 : 50.0;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================================================
              // ROLE NAME
              // ===================================================

              Text(
                'Role Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Enter the role name and description.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(
                height: isSmall ? 16 : 20,
              ),

              // ===================================================
              // ROLE NAME
              // ===================================================

              TextFormField(
                controller: _roleNameController,
                enabled: !widget.isLoading,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Role Name',
                  hintText: 'Enter role name',
                  prefixIcon: const Icon(
                    Icons.admin_panel_settings_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      isSmall ? 10 : 12,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      isSmall ? 10 : 12,
                    ),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      isSmall ? 10 : 12,
                    ),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Role name is required';
                  }

                  return null;
                },
              ),

              SizedBox(height: fieldSpacing),

              // ===================================================
              // DESCRIPTION
              // ===================================================

              TextFormField(
                controller: _descriptionController,
                enabled: !widget.isLoading,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: isWide ? 4 : 3,
                minLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter role description',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(
                      bottom: 42,
                    ),
                    child: Icon(
                      Icons.description_outlined,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      isSmall ? 10 : 12,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      isSmall ? 10 : 12,
                    ),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      isSmall ? 10 : 12,
                    ),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
              ),

              SizedBox(height: fieldSpacing),

              // ===================================================
              // ACTIVE STATUS CARD
              // ===================================================

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 12 : 14,
                  vertical: isSmall ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(
                    isSmall ? 10 : 12,
                  ),
                  border: Border.all(
                    color: colorScheme.outlineVariant
                        .withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    // ===========================================
                    // ICON
                    // ===========================================

                    Container(
                      width: isSmall ? 38 : 42,
                      height: isSmall ? 38 : 42,
                      decoration: BoxDecoration(
                        color: _isActive
                            ? colorScheme.primaryContainer
                            : colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(
                          isSmall ? 9 : 10,
                        ),
                      ),
                      child: Icon(
                        _isActive
                            ? Icons.check_circle_outline_rounded
                            : Icons.cancel_outlined,
                        size: isSmall ? 20 : 22,
                        color: _isActive
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onErrorContainer,
                      ),
                    ),

                    SizedBox(
                      width: isSmall ? 10 : 12,
                    ),

                    // ===========================================
                    // TEXT
                    // ===========================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isActive
                                ? 'This role is currently active'
                                : 'This role is currently inactive',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                              colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ===========================================
                    // SWITCH
                    // ===========================================

                    Switch(
                      value: _isActive,
                      onChanged: widget.isLoading
                          ? null
                          : (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: isSmall ? 20 : 24,
              ),

              // ===================================================
              // SAVE / UPDATE BUTTON
              // ===================================================

              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: FilledButton.icon(
                  onPressed: widget.isLoading ? null : _save,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isSmall ? 10 : 12,
                      ),
                    ),
                  ),
                  icon: widget.isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : Icon(
                    widget.initialRoleName
                        .trim()
                        .isEmpty
                        ? Icons.add_rounded
                        : Icons.save_outlined,
                  ),
                  label: Text(
                    widget.initialRoleName.trim().isEmpty
                        ? 'Save'
                        : 'Update',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}