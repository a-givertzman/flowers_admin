import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Product"
class EntryProduct implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
	  'id': FieldValue(0),
	  'product_category_id': FieldValue(0),
	  'category': FieldValue(''),
	  'name': FieldValue(''),
	  'details': FieldValue(''),
	  'primary_price': FieldValue('0.00'),
	  'primary_currency': FieldValue(''),
	  'primary_order_quantity': FieldValue('0'),
	  'order_quantity': FieldValue('0'),
	  'description': FieldValue(''),
	  'picture': FieldValue(''),
	  'created': FieldValue(''),
	  'updated': FieldValue(''),
	  'deleted': FieldValue(''),
    };
    return initial;
  }
  ///
  /// Single row of table "Product"
  /// - [keys] - list of field names
  EntryProduct({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  @override
  EntryProduct.from(Map<String, dynamic> row): _entry = SchemaEntry(map: _initial) {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryProduct.empty(): _entry = SchemaEntry(map: _initial);
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
