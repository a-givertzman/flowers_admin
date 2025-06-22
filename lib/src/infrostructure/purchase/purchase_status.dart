import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_status.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Represents a list of posible Purchase statuses in the DB
enum PurchaseStatus {
  /// Preparation stady (Is not visible to the clients, visible to admins and operators only)
  prepare,
  /// Active staty (Is visible to the clients, orders avalible)
  active,
  /// Wholesale purchase from vendor (Is visible to the clients, orders not avalible)
  purchase,
  /// Destributions orders to the clients (Is visible to the clients, orders not avalible)
  distribute,
  /// Moved to the archive (Is visible to the clients only in the archive, orders not possible)
  archived,
  /// Canceled (Is visible to the clients, marked as canceled, orders not possible)
  canceled,
  /// Can be supplied while read error from database, not for using (Visible to admins only)
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
  // Returns map of all [PurchaseStatus] values
  static final relation = PurchaseStatus.values.asMap().map((i, status) {
    return MapEntry(status.str, EntryPurchaseStatus(map: {'id': FieldValue(status.str), 'status': FieldValue(status.str)}));
  });
}
extension ParseToString on PurchaseStatus {
  String get str {
    return toString().split('.').last;
  }
}
