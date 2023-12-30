import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_log.dart';

  final _initial = <String, FieldValue>{
    'id': FieldValue(0),
    'role': FieldValue('customer'),
    'email': FieldValue('@'),
    'phone': FieldValue('+7'),
    'name': FieldValue(''),
    'location': FieldValue(''),
    'login': FieldValue(''),
    'pass': FieldValue(''),
    'account': FieldValue('0'),
    'last_act': FieldValue(null),
    'blocked': FieldValue(null),
    'created': FieldValue(null),
    'updated': FieldValue(null),
    'deleted': FieldValue(null),
  };
///
/// Single row of table "Customer"
class EntryCustomer implements SchemaEntryAbstract {
  final _log = Log("$EntryCustomer");
  late final SchemaEntry _entry;
  ///
  /// Single row of table "Customer"
  /// - [keys] - list of field names
  EntryCustomer({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  EntryCustomer.from(Map<String, FieldValue> row) {
    _log.debug('.from | row: $row');
    final initial = <String, FieldValue>{};
    initial.addAll(_initial);
    _entry = SchemaEntry(map: initial);
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryCustomer.empty(): _entry = SchemaEntry(map: Map.from(_initial));
  //
  //
  @override
  String get key => _entry.key;
  //
  //
  @override
  bool get isChanged => _entry.isChanged;
  //
  //
  @override
  bool get isSelected => _entry.isSelected;
  //
  //
  @override
  FieldValue value(String key) => _entry.value(key);
  //
  //  
  @override
  void update(String key, dynamic value) => _entry.update(key, value);
  //
  //
  @override
  void select(bool selected) => _entry.select(selected);
  //
  //
  @override
  void saved() => _entry.saved();
  //
  //
  @override
  String toString() => _entry.toString();  
}
