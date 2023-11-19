import 'package:flowers_admin/src/core/error/failure.dart';
import 'package:flowers_admin/src/infrostructure/schames/field_value.dart';
import 'package:flowers_admin/src/infrostructure/schames/scheme_entry.dart';
import 'package:uuid/uuid.dart';

///
/// Single row of table "Customer"
class EntryProduct implements SchemeEntry {
  final _id = const Uuid().v1();  // v1 time-based id
  bool _changed = false;
  late final Map<String, FieldValue> _map;
  ///
  /// Single row of table "Customer"
  /// - [keys] - list of field names
  EntryProduct({
    required Map<String, FieldValue> map,
  }) :
    _map = map;
  //
  //
  EntryProduct.empty();
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
  }
  //
  @override
  EntryProduct.from(Map<String, dynamic> row) {
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
