import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Transaction"
class EntryTransaction implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  ///
  /// Single row of table "Transaction"
  /// - [keys] - list of field names
  EntryTransaction({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  @override
  EntryTransaction.from(Map<String, dynamic> row): _entry = SchemaEntry.empty() {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, FieldValue(value));
    }
  }
  //
  //
  EntryTransaction.empty(): _entry = SchemaEntry.empty() {
	    _entry.update('id', FieldValue(''));
	    _entry.update('timestamp', FieldValue(''));
	    _entry.update('account_owner', FieldValue(''));
	    _entry.update('value', FieldValue(''));
	    _entry.update('description', FieldValue(''));
	    _entry.update('order_id', FieldValue(''));
	    _entry.update('customer_id', FieldValue(''));
	    _entry.update('customer_account', FieldValue(''));
	    _entry.update('created', FieldValue(''));
	    _entry.update('updated', FieldValue(''));
	    _entry.update('deleted', FieldValue(''));
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
