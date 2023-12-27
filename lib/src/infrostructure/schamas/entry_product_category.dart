import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/error/failure.dart';
import 'package:uuid/uuid.dart';

///
/// Single row of table "Customer"
class EntryProductCategory implements SchemaEntry {
  final _id = const Uuid().v1();  // v1 time-based id
  bool _changed = false;
  bool _isSelected = false;
  late final Map<String, FieldValue> _map;
  ///
  /// Single row of table "Customer"
  /// - [keys] - list of field names
  EntryProductCategory({
    required Map<String, FieldValue> map,
  }) :
    _map = map;
  //
  //
  EntryProductCategory.empty();
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
  bool get isSelected => _isSelected;
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
  EntryProductCategory.from(Map<String, dynamic> row) {
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
  //
  //
  @override
  void select(bool selected) {
    if (_isSelected != selected) _isSelected = selected;
  }
  //
  //
  @override
  String toString() {
    return '$runtimeType{ isChanged: $_changed, isSelected: $_isSelected, map: $_map}';
  }
}
