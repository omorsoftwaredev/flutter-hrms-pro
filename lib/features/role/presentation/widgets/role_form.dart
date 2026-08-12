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
  State<RoleForm> createState() =>
      _RoleFormState();
}

class _RoleFormState
    extends State<RoleForm> {
  final _formKey =
  GlobalKey<FormState>();

  late TextEditingController
  _roleNameController;

  late TextEditingController
  _descriptionController;

  late bool _isActive;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _roleNameController =
        TextEditingController(
          text: widget.initialRoleName,
        );

    _descriptionController =
        TextEditingController(
          text: widget.initialDescription,
        );

    _isActive =
        widget.initialIsActive;
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
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final roleName =
    _roleNameController.text.trim();

    final description =
    _descriptionController.text.trim();

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
  Widget build(
      BuildContext context,
      ) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // =====================================================
          // ROLE NAME
          // =====================================================

          TextFormField(
            controller:
            _roleNameController,
            decoration:
            const InputDecoration(
              labelText: 'Role Name',
              border:
              OutlineInputBorder(),
            ),
            textInputAction:
            TextInputAction.next,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Role name is required';
              }

              return null;
            },
          ),

          const SizedBox(
            height: 16,
          ),

          // =====================================================
          // DESCRIPTION
          // =====================================================

          TextFormField(
            controller:
            _descriptionController,
            decoration:
            const InputDecoration(
              labelText: 'Description',
              border:
              OutlineInputBorder(),
            ),
            maxLines: 3,
          ),

          const SizedBox(
            height: 16,
          ),

          // =====================================================
          // ACTIVE
          // =====================================================

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,
            title:
            const Text('Active'),
            value: _isActive,
            onChanged:
            widget.isLoading
                ? null
                : (value) {
              setState(() {
                _isActive =
                    value;
              });
            },
          ),

          const SizedBox(
            height: 24,
          ),

          // =====================================================
          // SAVE / UPDATE BUTTON
          // =====================================================

          SizedBox(
            width:
            double.infinity,
            height: 48,
            child: FilledButton(
              onPressed:
              widget.isLoading
                  ? null
                  : _save,
              child: widget.isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : Text(
                widget.initialRoleName
                    .trim()
                    .isEmpty
                    ? 'Save'
                    : 'Update',
              ),
            ),
          ),
        ],
      ),
    );
  }
}