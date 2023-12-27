import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "PurchaseContent"
class EntryPurchaseContent implements SchemaEntryAbstract {
  static final _initial = {
	    'id': FieldValue(null),
	    'purchase_id': FieldValue(null),
	    'product_id': FieldValue(null),
	    'sale_price': FieldValue('0.00'),
	    'sale_currency': FieldValue(''),
	    'shipping': FieldValue('0.00'),
	    'amount': FieldValue('0.00'),
	    'name': FieldValue(''),
	    'details': FieldValue(''),
	    'description': FieldValue(''),
	    'picture': FieldValue(''),
	    'created': FieldValue(''),
	    'updated': FieldValue(''),
	    'deleted': FieldValue(''),
  };
  final SchemaEntry _entry;
  ///
  /// Single row of table "PurchaseContent"
  /// - [keys] - list of field names
  EntryPurchaseContent({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  @override
  EntryPurchaseContent.from(Map<String, dynamic> row): _entry = SchemaEntry(map: Map.from(_initial)) {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryPurchaseContent.empty(): _entry = SchemaEntry(map: Map.from(_initial));
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
