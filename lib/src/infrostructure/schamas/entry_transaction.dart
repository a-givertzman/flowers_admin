import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/error/failure.dart';
import 'package:uuid/uuid.dart';

///
/// Single row of table "Customer"
class EntryTransaction implements SchemaEntry {
  final _id = const Uuid().v1();  // v1 time-based id
  bool _changed = false;
  late final Map<String, FieldValue> _map;
  ///
  /// Single row of table "Customer"
  /// - [keys] - list of field names
  EntryTransaction({
    required Map<String, FieldValue> map,
  }) :
    _map = map;
  //
  //
  EntryTransaction.empty() {
    _map = {
      'id': FieldValue(null),
      'timestamp': FieldValue( DateTime.now().toIso8601String() ),
      'account_owner': FieldValue(''),
      'value': FieldValue('0'),
      'description': FieldValue(''),
      'order_id': FieldValue(null),
      'customer_id': FieldValue('0'),
      'customer_account': FieldValue('0'),
      'created': FieldValue(null),
      'updated': FieldValue(null),
      'deleted': FieldValue(null),
    };
  }
  //
  //
  @override
  String get key => _id;
  //
  //
  @override
  bool get isChanged => _changed;
  //
  //
  @override
  FieldValue value(String key) {
    final value = _map[key];
    if (value != null) {
      return value;
    }
    throw Failure(
      message: "$runtimeType.value | key '$key' - not found", 
      stackTrace: StackTrace.current,
    );
  }  //
  //
  @override
  EntryTransaction.from(Map<String, dynamic> row) {
    _map =row.map((key, value) {
      return MapEntry(key, FieldValue(value));
    });
  }
  //
  //  
  @override
  void update(String key, String value) {
    if (!_map.containsKey(key)) {
      throw Failure(
        message: "$runtimeType.update | key '$key' - not found", 
        stackTrace: StackTrace.current,
      );
    }
    final field = _map[key];
    if (field != null) {
      _changed = field.update(value);
    }
  }
}
