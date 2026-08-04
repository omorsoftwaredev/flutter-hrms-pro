import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/presentation/providers/company_provider.dart';
import '../../../role/presentation/providers/role_provider.dart';


class RolePermissionsForm extends ConsumerStatefulWidget {

  const RolePermissionsForm({
    super.key,

    this.initialCompanyId = '',
    this.initialRoleId = '',

    this.initialModuleName = '',

    this.initialCanView = false,
    this.initialCanCreate = false,
    this.initialCanUpdate = false,
    this.initialCanDelete = false,
    this.initialCanExport = false,
    this.initialCanApprove = false,

    this.isLoading = false,

    required this.onSubmit,
  });


  final String initialCompanyId;

  final String initialRoleId;


  final String initialModuleName;


  final bool initialCanView;
  final bool initialCanCreate;
  final bool initialCanUpdate;
  final bool initialCanDelete;
  final bool initialCanExport;
  final bool initialCanApprove;


  final bool isLoading;



  final Future<void> Function(
      String companyId,
      String roleId,
      String moduleName,
      bool canView,
      bool canCreate,
      bool canUpdate,
      bool canDelete,
      bool canExport,
      bool canApprove,
      ) onSubmit;



  @override
  ConsumerState<RolePermissionsForm> createState() =>
      _RolePermissionsFormState();

}




class _RolePermissionsFormState
    extends ConsumerState<RolePermissionsForm> {


  final _formKey =
  GlobalKey<FormState>();


  late TextEditingController _moduleController;


  String? _companyId;

  String? _roleId;



  bool _canView = false;
  bool _canCreate = false;
  bool _canUpdate = false;
  bool _canDelete = false;
  bool _canExport = false;
  bool _canApprove = false;



  @override
  void initState() {

    super.initState();


    _companyId =
    widget.initialCompanyId.isEmpty
        ? null
        : widget.initialCompanyId;


    _roleId =
    widget.initialRoleId.isEmpty
        ? null
        : widget.initialRoleId;



    _moduleController =
        TextEditingController(
          text: widget.initialModuleName,
        );


    _canView = widget.initialCanView;
    _canCreate = widget.initialCanCreate;
    _canUpdate = widget.initialCanUpdate;
    _canDelete = widget.initialCanDelete;
    _canExport = widget.initialCanExport;
    _canApprove = widget.initialCanApprove;


  }





  @override
  void dispose() {

    _moduleController.dispose();

    super.dispose();

  }






  Future<void> _save() async {


    if(!_formKey.currentState!.validate()){
      return;
    }



    if(_companyId == null){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text('Please select company'),
        ),
      );

      return;

    }



    if(_roleId == null){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text('Please select role'),
        ),
      );

      return;

    }




    await widget.onSubmit(

      _companyId!,

      _roleId!,

      _moduleController.text.trim(),

      _canView,

      _canCreate,

      _canUpdate,

      _canDelete,

      _canExport,

      _canApprove,

    );


  }








  Widget permissionSwitch(
      String title,
      bool value,
      Function(bool) onChanged,
      ){

    return SwitchListTile(

      title: Text(title),

      value: value,

      onChanged: onChanged,

    );

  }








  @override
  Widget build(BuildContext context) {


    final companyState =
    ref.watch(companyProvider);



    final roleState =
    ref.watch(roleProvider);



    final filteredRoles =
    roleState.roles
        .where(
          (role)=>
      role.companyId == _companyId,
    )
        .toList();




    return Form(

      key: _formKey,


      child: SingleChildScrollView(


        child: Column(

          children: [



            DropdownButtonFormField<String>(


              value: _companyId,


              decoration:
              const InputDecoration(

                labelText:
                'Select Company',

                border:
                OutlineInputBorder(),

              ),



              items:
              companyState.companies
                  .map(
                    (company)=>DropdownMenuItem(

                  value: company.id,

                  child:
                  Text(company.name),

                ),

              )
                  .toList(),



              onChanged:(value){

                setState(() {

                  _companyId = value;

                  // company change হলে role reset
                  _roleId = null;

                });

              },


            ),




            const SizedBox(
              height:16,
            ),






            DropdownButtonFormField<String>(


              value: _roleId,


              decoration:
              const InputDecoration(

                labelText:
                'Select Role',

                border:
                OutlineInputBorder(),

              ),



              items:
              filteredRoles
                  .map(
                    (role)=>DropdownMenuItem(

                  value: role.id,

                  child:
                  Text(role.roleName),

                ),

              )
                  .toList(),




              onChanged:
              _companyId == null
                  ? null
                  : (value){

                setState(() {

                  _roleId = value;

                });

              },


            ),





            const SizedBox(
              height:16,
            ),





            TextFormField(

              controller:
              _moduleController,


              decoration:
              const InputDecoration(

                labelText:
                'Module Name',

                border:
                OutlineInputBorder(),

              ),


              validator:(value){

                if(value == null ||
                    value.trim().isEmpty){

                  return 'Required';

                }

                return null;

              },

            ),






            permissionSwitch(
                'View',
                _canView,
                    (v)=>setState(
                        ()=>_canView=v
                )
            ),


            permissionSwitch(
                'Create',
                _canCreate,
                    (v)=>setState(
                        ()=>_canCreate=v
                )
            ),


            permissionSwitch(
                'Update',
                _canUpdate,
                    (v)=>setState(
                        ()=>_canUpdate=v
                )
            ),


            permissionSwitch(
                'Delete',
                _canDelete,
                    (v)=>setState(
                        ()=>_canDelete=v
                )
            ),


            permissionSwitch(
                'Export',
                _canExport,
                    (v)=>setState(
                        ()=>_canExport=v
                )
            ),


            permissionSwitch(
                'Approve',
                _canApprove,
                    (v)=>setState(
                        ()=>_canApprove=v
                )
            ),





            const SizedBox(
              height:24,
            ),




            SizedBox(

              width:
              double.infinity,

              height:
              48,


              child: FilledButton(


                onPressed:
                widget.isLoading
                    ? null
                    : _save,



                child:

                widget.isLoading

                    ? const CircularProgressIndicator()

                    :

                Text(

                  widget.initialModuleName.isEmpty
                      ? 'Save'
                      : 'Update',

                ),

              ),

            ),


          ],

        ),

      ),

    );


  }


}