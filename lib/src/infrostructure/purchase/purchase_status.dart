import 'package:hmi_core/hmi_core_log.dart';
///
/// Represents a list of posible Purchase statuses in the DB
enum PurchaseStatus {
  prepare,
  active,
  purchase,
  distribute,
  archived,
  canceled,
  notsampled;
  ///
  /// Creates [PurchaseStatus] from database string value
  factory PurchaseStatus.from(String value) {
    final _log = Log('$PurchaseStatus');
    switch (value.toLowerCase()) {
      case 'prepare':
        return PurchaseStatus.prepare;
      case 'active':
        return PurchaseStatus.active;
      case 'purchase':
        return PurchaseStatus.purchase;
      case 'distribute':
        return PurchaseStatus.distribute;
      case 'archived':
        return PurchaseStatus.archived;
      case 'canceled':
        return PurchaseStatus.canceled;
      case 'notsampled':
        return PurchaseStatus.notsampled;
      default:
        _log.error('.from | Unknown Purchase Status: \'$value\'');
        return PurchaseStatus.notsampled;
    }
  }
}
extension ParseToString on PurchaseStatus {
  String get str {
    return toString().split('.').last;
  }
}
