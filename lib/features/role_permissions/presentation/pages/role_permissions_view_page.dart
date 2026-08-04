import 'package:flutter/material.dart';

import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';

import '../../domain/entities/role_permissions_view_entity.dart';



class RolePermissionsViewPage extends StatelessWidget {


  const RolePermissionsViewPage({
    super.key,
    required this.data,
  });



  final RolePermissionsViewEntity data;



  @override
  Widget build(BuildContext context) {


    final permission = data.permission;



    return Scaffold(


      appBar: AppBar(

        title: const Text(
          'Role Permission Details',
        ),

      ),




      body: ListView(


        padding:
        const EdgeInsets.all(16),



        children: [




          Card(


            elevation: 2,


            child: Padding(


              padding:
              const EdgeInsets.all(24),



              child: Column(


                children: [



                  const CircleAvatar(


                    radius: 36,


                    child: Icon(

                      Icons.security,

                      size:40,

                    ),

                  ),




                  const SizedBox(height:16),




                  Text(

                    permission.moduleName,

                    style:
                    Theme.of(context)
                        .textTheme
                        .headlineSmall,

                  ),




                  const SizedBox(height:8),





                  AppStatusChip(

                    isActive:
                    permission.canView,

                  ),



                ],


              ),


            ),


          ),





          const SizedBox(height:16),





          Card(


            elevation:2,


            child: Padding(


              padding:
              const EdgeInsets.all(16),



              child: Column(


                children: [




                  AppDetailTile(

                    title:'Company',

                    value:
                    data.companyName,

                  ),




                  AppDetailTile(

                    title:'Role',

                    value:
                    data.roleName,

                  ),





                  AppDetailTile(

                    title:'Module Name',

                    value:
                    permission.moduleName,

                  ),




                  AppDetailTile(

                    title:'View Permission',

                    value:
                    permission.canView
                        ? 'Allowed'
                        : 'Denied',

                  ),





                  AppDetailTile(

                    title:'Create Permission',

                    value:
                    permission.canCreate
                        ? 'Allowed'
                        : 'Denied',

                  ),





                  AppDetailTile(

                    title:'Update Permission',

                    value:
                    permission.canUpdate
                        ? 'Allowed'
                        : 'Denied',

                  ),





                  AppDetailTile(

                    title:'Delete Permission',

                    value:
                    permission.canDelete
                        ? 'Allowed'
                        : 'Denied',

                  ),





                  AppDetailTile(

                    title:'Export Permission',

                    value:
                    permission.canExport
                        ? 'Allowed'
                        : 'Denied',

                  ),





                  AppDetailTile(

                    title:'Approve Permission',

                    value:
                    permission.canApprove
                        ? 'Allowed'
                        : 'Denied',

                  ),





                  AppDetailTile(

                    title:'Created At',

                    value:
                    permission.createdAt.toString(),

                  ),




                  AppDetailTile(

                    title:'Updated At',

                    value:
                    permission.updatedAt?.toString()
                        ??
                        '-',

                  ),



                ],

              ),

            ),

          ),



        ],

      ),


    );

  }

}