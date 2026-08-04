import 'role_permissions_entity.dart';


class RolePermissionsViewEntity {

  const RolePermissionsViewEntity({

    required this.permission,

    required this.companyName,

    required this.roleName,

  });



  final RolePermissionsEntity permission;


  final String companyName;


  final String roleName;



  RolePermissionsViewEntity copyWith({

    RolePermissionsEntity? permission,

    String? companyName,

    String? roleName,

  }) {

    return RolePermissionsViewEntity(

      permission:
      permission ?? this.permission,


      companyName:
      companyName ?? this.companyName,


      roleName:
      roleName ?? this.roleName,

    );

  }

}