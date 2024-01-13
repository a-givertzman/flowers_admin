import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Transaction"
class EntryTransaction implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
	    'id': FieldValue(0),
	    'timestamp': FieldValue(''),
	    'account_owner': FieldValue(''),
	    'value': FieldValue(''),
	    'description': FieldValue(''),
	    'order_id': FieldValue(''),
	    'customer_id': FieldValue(''),
	    'customer_account': FieldValue(''),
	    'created': FieldValue(''),
	    'updated': FieldValue(''),
	    'deleted': FieldValue(''),
    };
    return initial;
  }
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
  EntryTransaction.from(Map<String, dynamic> row): _entry = SchemaEntry(map: _initial) {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryTransaction.empty(): _entry = SchemaEntry(map: _initial);
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
