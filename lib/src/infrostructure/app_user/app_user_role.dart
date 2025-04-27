import 'package:hmi_core/hmi_core_log.dart';
///
/// Represents a list of possible roles of the user, stored in the DB
/// - Admin
/// - Operator
/// - Costomer
enum AppUserRole {
  admin,
  operator,
  guest,
  customer;
  ///
  /// Creates [AppUserRole] from database string value
  factory AppUserRole.from(String value) {
    final _log = Log("$AppUserRole");
    switch (value.toLowerCase()) {
      case 'admin':
        return AppUserRole.admin;
      case 'operator':
        return AppUserRole.operator;
      case 'customer':
        return AppUserRole.customer;
      default:
        _log.error('.from | Unknown User role: \'$value\'');
        return AppUserRole.guest;
    }
  }
}
extension ParseToString on AppUserRole {
  String get str {
    return toString().split('.').last;
  }
}
