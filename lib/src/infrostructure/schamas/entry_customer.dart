import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Customer"
class EntryCustomer implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  ///
  /// Single row of table "Customer"
  /// - [keys] - list of field names
  EntryCustomer({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  @override
  EntryCustomer.from(Map<String, dynamic> row): _entry = SchemaEntry.empty() {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, FieldValue(value));
    }
  }
  //
  //
  EntryCustomer.empty(): _entry = SchemaEntry.empty() {
    _entry.update('id', FieldValue(null));
    _entry.update('role', FieldValue('customer'));
    _entry.update('email', FieldValue('@'));
    _entry.update('phone', FieldValue('+7'));
    _entry.update('name', FieldValue(''));
    _entry.update('location', FieldValue(''));
    _entry.update('login', FieldValue(''));
    _entry.update('pass', FieldValue(''));
    _entry.update('account', FieldValue('0'));
    _entry.update('last_act', FieldValue(null));
    _entry.update('blocked', FieldValue(null));
    _entry.update('created', FieldValue(null));
    _entry.update('updated', FieldValue(null));
    _entry.update('deleted', FieldValue(null));
    }
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
  void update(String key, String value) => _entry.update(key, value);
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
