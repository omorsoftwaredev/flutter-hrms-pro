import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_section_title.dart';


import '../providers/role_permissions_provider.dart';
import '../widgets/role_permissions_card.dart';


class RolePermissionsListPage
    extends ConsumerStatefulWidget {

  const RolePermissionsListPage({
    super.key,
  });


  @override
  ConsumerState<RolePermissionsListPage>
  createState() =>
      _RolePermissionsListPageState();

}



class _RolePermissionsListPageState
    extends ConsumerState<RolePermissionsListPage> {

  final _searchController =
  TextEditingController();



  @override
  void initState() {

    super.initState();


    Future.microtask(() async {

      await ref
          .read(
        rolePermissionsProvider
            .notifier,
      )
          .loadRolePermissions();

    });


  }




  @override
  void dispose() {

    _searchController.dispose();

    super.dispose();

  }




  Future<void> _refresh() async {

    await ref
        .read(
      rolePermissionsProvider
          .notifier,
    )
        .refresh();

  }




  @override
  Widget build(BuildContext context) {


    final state =
    ref.watch(
        rolePermissionsProvider
    );



    return Scaffold(


      appBar: AppBar(

        title: const Text(
          'Role Permissions',
        ),

      ),




      floatingActionButton:
      FloatingActionButton.extended(


        onPressed: () {

          context.push(
            RoutePaths.rolePermissionsCreate,
          );

        },


        icon:
        const Icon(
          Icons.add,
        ),


        label:
        const Text(
          'Add Permission',
        ),


      ),




      body:
      RefreshIndicator(


        onRefresh: _refresh,



        child: Padding(


          padding:
          const EdgeInsets.all(16),



          child: Column(


            children: [



              AppSearchField(


                controller:
                _searchController,


                onChanged: (value){

                  ref
                      .read(
                    rolePermissionsProvider
                        .notifier,
                  )
                      .search(value);


                },


              ),




              const SizedBox(
                height:20,
              ),




              AppSectionTitle(

                title:
                'Permission List (${state.filteredPermissions.length})',

              ),




              const SizedBox(
                height:12,
              ),




              Expanded(


                child: Builder(


                  builder: (_) {


                    if(state.isLoading){

                      return const AppLoading();

                    }




                    if(state
                        .filteredPermissions
                        .isEmpty){


                      return ListView(

                        children: const [

                          SizedBox(
                            height:120,
                          ),


                          AppEmpty(

                            title:
                            'No Permission Found',

                          ),

                        ],

                      );

                    }





                    return ListView.separated(



                      physics:
                      const AlwaysScrollableScrollPhysics(),




                      itemCount:
                      state
                          .filteredPermissions
                          .length,




                      separatorBuilder:
                          (_,__)=>
                      const SizedBox(
                        height:12,
                      ),





                      itemBuilder:
                          (_,index){



                        final permission =
                        state
                            .filteredPermissions[index];





                        return
                          RolePermissionsCard(
                            data: permission,
                          onView: (){
                            context.push(

                              RoutePaths
                                  .rolePermissionsView,

                              extra:
                              permission,

                            );


                          },




                            onEdit: (){

                              context.push(
                                RoutePaths.rolePermissionsEdit,
                                extra: permission.permission,
                              );

                            },





                          onDelete:
                              () async {



                            final confirm =
                            await showDialog<bool>(

                              context:
                              context,


                              builder:
                                  (_)=>

                                  AlertDialog(

                                    title:
                                    const Text(
                                      'Delete Permission',
                                    ),


                                    content:
                                    Text(

                                      'Are you sure you want to delete "${permission.permission.moduleName}"?',

                                    ),


                                    actions:[



                                      OutlinedButton(

                                        onPressed:(){

                                          Navigator.pop(
                                            context,
                                            false,
                                          );

                                        },

                                        child:
                                        const Text(
                                          'Cancel',
                                        ),

                                      ),




                                      FilledButton(

                                        onPressed:(){

                                          Navigator.pop(
                                            context,
                                            true,
                                          );

                                        },


                                        child:
                                        const Text(
                                          'Delete',
                                        ),

                                      ),


                                    ],

                                  ),

                            );





                            if(confirm != true){

                              return;

                            }




                            await ref
                                .read(
                              rolePermissionsProvider
                                  .notifier,
                            )
                                .deleteRolePermission(
                              permission.permission.id,
                            );





                            if(context.mounted){


                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                SnackBar(

                                  content:
                                  Text(

                                      '${permission.permission.moduleName} deleted successfully.'

                                  ),

                                ),

                              );


                            }


                          },



                        );


                      },


                    );


                  },

                ),

              ),



            ],


          ),


        ),


      ),


    );


  }


}