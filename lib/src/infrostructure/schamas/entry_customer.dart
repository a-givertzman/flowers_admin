import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_log.dart';

///
/// Single row of table "Customer"
class EntryCustomer implements SchemaEntryAbstract {
  final _log = Log("$EntryCustomer");
  late final SchemaEntry _entry;
  final bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
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
    return initial;
  }
  ///
  /// Single row of table "Customer"
  /// - [keys] - list of field names
  EntryCustomer({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  EntryCustomer.from(Map<String, dynamic> row):
    _entry = SchemaEntry(map: _initial),
    _isEmpty = false {
    _log.debug('.from | row: $row');
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
    _log.debug('.from | _entry: $_entry');
  }
  //
  //
  EntryCustomer.empty(): 
    _entry = SchemaEntry(map: _initial),
    _isEmpty = true;
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
  bool get isEmpty => _isEmpty;
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
