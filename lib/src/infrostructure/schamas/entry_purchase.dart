import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Purchase"
class EntryPurchase implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  ///
  /// Single row of table "Purchase"
  /// - [keys] - list of field names
  EntryPurchase({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  @override
  EntryPurchase.from(Map<String, dynamic> row): _entry = SchemaEntry.empty() {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, FieldValue(value));
    }
  }
  //
  //
  EntryPurchase.empty(): _entry = SchemaEntry.empty() {
	    _entry.update('id', FieldValue(null));
	    _entry.update('name', FieldValue(''));
	    _entry.update('details', FieldValue(''));
	    _entry.update('status', FieldValue(''));
	    _entry.update('date_of_start', FieldValue(''));
	    _entry.update('date_of_end', FieldValue(''));
	    _entry.update('description', FieldValue(''));
	    _entry.update('picture', FieldValue(''));
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
