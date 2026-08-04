import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

import '../../../company/presentation/providers/company_provider.dart';
import '../../../role/presentation/providers/role_provider.dart';

import '../../domain/entities/role_permissions_entity.dart';

import '../providers/role_permissions_provider.dart';
import '../widgets/role_permissions_form.dart';

class RolePermissionsFormPage extends ConsumerStatefulWidget {

  const RolePermissionsFormPage({
    super.key,
    this.permission,
  });

  final RolePermissionsEntity? permission;


  @override
  ConsumerState<RolePermissionsFormPage> createState() =>
      _RolePermissionsFormPageState();

}



class _RolePermissionsFormPageState
    extends ConsumerState<RolePermissionsFormPage> {
  bool get isEdit => widget.permission != null;

  @override
  void initState() {

    super.initState();


    Future.microtask(() async {

      await ref
          .read(companyProvider.notifier)
          .loadCompanies();


      await ref
          .read(roleProvider.notifier)
          .loadRoles();


    });

  }







  @override
  Widget build(
      BuildContext context,
      ) {


    final permission =
        widget.permission;



    final state =
    ref.watch(
      rolePermissionsProvider,
    );




    return Scaffold(


      appBar: AppBar(

        title: Text(

          isEdit
              ? 'Edit Permission'
              : 'Add Permission',

        ),

      ),





      body: SafeArea(


        child: Padding(


          padding:
          const EdgeInsets.all(16),




          child: RolePermissionsForm(



            initialCompanyId:

            permission?.companyId ?? '',





            initialRoleId:

            permission?.roleId ?? '',






            initialModuleName:

            permission?.moduleName ?? '',






            initialCanView:

            permission?.canView ?? false,





            initialCanCreate:

            permission?.canCreate ?? false,





            initialCanUpdate:

            permission?.canUpdate ?? false,





            initialCanDelete:

            permission?.canDelete ?? false,





            initialCanExport:

            permission?.canExport ?? false,





            initialCanApprove:

            permission?.canApprove ?? false,






            isLoading:

            state.isSaving,







            onSubmit: (


                companyId,


                roleId,


                moduleName,


                canView,


                canCreate,


                canUpdate,


                canDelete,


                canExport,


                canApprove,


                ) async {



              final entity =

              RolePermissionsEntity(


                id:

                permission?.id ?? '',




                companyId:

                companyId,




                roleId:

                roleId,




                moduleName:

                moduleName,




                canView:

                canView,




                canCreate:

                canCreate,




                canUpdate:

                canUpdate,




                canDelete:

                canDelete,




                canExport:

                canExport,




                canApprove:

                canApprove,




                createdAt:

                permission?.createdAt ??
                    DateTime.now(),




                updatedAt:

                DateTime.now(),


              );








              try {



                if(isEdit){



                  await ref
                      .read(
                    rolePermissionsProvider
                        .notifier,
                  )
                      .updateRolePermission(
                    entity,
                  );



                }else{



                  await ref
                      .read(
                    rolePermissionsProvider
                        .notifier,
                  )
                      .createRolePermission(
                    entity,
                  );



                }








                if(!context.mounted) return;






                ScaffoldMessenger.of(context)
                    .showSnackBar(


                  SnackBar(

                    content:

                    Text(

                      isEdit

                          ? 'Permission updated successfully.'

                          : 'Permission created successfully.',

                    ),

                  ),


                );







                context.go(

                  RoutePaths.rolePermissions,

                );







              } catch(e) {



                if(!context.mounted) return;





                ScaffoldMessenger.of(context)
                    .showSnackBar(



                  SnackBar(

                    content:

                    Text(

                      e.toString(),

                    ),

                  ),


                );


              }



            },


          ),



        ),


      ),


    );


  }


}