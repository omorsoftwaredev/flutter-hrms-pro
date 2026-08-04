// role_form.dart
// Complete compile-ready RoleForm widget.
// (Generated placeholder based on your requested API.)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/domain/entities/company_entity.dart';
import '../../../company/presentation/providers/company_provider.dart';

class RoleForm extends ConsumerStatefulWidget {
  const RoleForm({
    super.key,
    this.initialCompanyId='',
    this.initialRoleCode='',
    this.initialRoleName='',
    this.initialDescription='',
    this.initialIsActive=true,
    this.isLoading=false,
    required this.onSubmit,
  });

  final String initialCompanyId;
  final String initialRoleCode;
  final String initialRoleName;
  final String initialDescription;
  final bool initialIsActive;
  final bool isLoading;

  final Future<void> Function(
      String companyId,
      String roleCode,
      String roleName,
      String description,
      bool isActive,
      ) onSubmit;

  @override
  ConsumerState<RoleForm> createState()=>_RoleFormState();
}

class _RoleFormState extends ConsumerState<RoleForm>{
  final _formKey=GlobalKey<FormState>();
  late final TextEditingController _roleCodeController;
  late final TextEditingController _roleNameController;
  late final TextEditingController _descriptionController;
  String? _companyId;
  bool _isActive=true;

  @override
  void initState(){
    super.initState();
    _companyId=widget.initialCompanyId.isEmpty?null:widget.initialCompanyId;
    _roleCodeController=TextEditingController(text:widget.initialRoleCode);
    _roleNameController=TextEditingController(text:widget.initialRoleName);
    _descriptionController=TextEditingController(text:widget.initialDescription);
    _isActive=widget.initialIsActive;
    Future.microtask(()=>ref.read(companyProvider.notifier).loadCompanies());
  }

  @override
  void dispose(){
    _roleCodeController.dispose();
    _roleNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async{
    if(!_formKey.currentState!.validate()||_companyId==null)return;
    await widget.onSubmit(
      _companyId!,
      _roleCodeController.text.trim(),
      _roleNameController.text.trim(),
      _descriptionController.text.trim(),
      _isActive,
    );
  }

  @override
  Widget build(BuildContext context){
    final companies=ref.watch(companyProvider).companies;
    if(companies.isEmpty){return const Center(child:CircularProgressIndicator());}
    return Form(
        key:_formKey,
        child:Column(children:[
          DropdownButtonFormField<String>(
            value:_companyId,
            decoration:const InputDecoration(labelText:'Company',border:OutlineInputBorder()),
            items:companies.map((CompanyEntity e)=>DropdownMenuItem(value:e.id,child:Text(e.name))).toList(),
            onChanged:(v)=>setState(()=>_companyId=v),
            validator:(v)=>v==null?'Select Company':null,
          ),
          const SizedBox(height:16),
          TextFormField(controller:_roleCodeController,decoration:const InputDecoration(labelText:'Role Code',border:OutlineInputBorder()),validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:16),
          TextFormField(controller:_roleNameController,decoration:const InputDecoration(labelText:'Role Name',border:OutlineInputBorder()),validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:16),
          TextFormField(controller:_descriptionController,maxLines:3,decoration:const InputDecoration(labelText:'Description',border:OutlineInputBorder())),
          SwitchListTile(title:const Text('Active'),value:_isActive,onChanged:(v)=>setState(()=>_isActive=v)),
          const SizedBox(height:24),
          SizedBox(width:double.infinity,height:48,child:FilledButton(
            onPressed:widget.isLoading?null:_save,
            child:widget.isLoading?const CircularProgressIndicator():Text(widget.initialRoleCode.isEmpty?'Save':'Update'),
          ))
        ])
    );
  }
}
