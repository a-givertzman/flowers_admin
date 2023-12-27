import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Purchase"
class EntryPurchase implements SchemaEntryAbstract {
  static final _initial = {
	    'id': FieldValue(null),
	    'name': FieldValue(''),
	    'details': FieldValue(''),
	    'status': FieldValue(''),
	    'date_of_start': FieldValue(''),
	    'date_of_end': FieldValue(''),
	    'description': FieldValue(''),
	    'picture': FieldValue(''),
	    'created': FieldValue(''),
	    'updated': FieldValue(''),
	    'deleted': FieldValue(''),
  };
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
  EntryPurchase.from(Map<String, dynamic> row): _entry = SchemaEntry(map: _initial) {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryPurchase.empty(): _entry = SchemaEntry(map: _initial);
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
