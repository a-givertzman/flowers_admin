import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
///
/// Represents current authenticated user
/// - Refers to the table Customer
class AppUser {
  final String id;
  final String name;
  final AppUserRole role;
  final bool isEmpty;
  ///
  /// Creates new AppUser insatance
  const AppUser({
    required this.id,
    required this.name,
    required this.role,
  }):
    isEmpty = false;
  ///
  /// Creates new empty AppUser insatance
  const AppUser.empty():
    id = '',
    name = '',
    role = AppUserRole.guest,
    isEmpty = true;
}