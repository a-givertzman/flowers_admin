import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "PurchaseContent"
class EntryPurchaseContent implements SchemaEntryAbstract {
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
  EntryPurchaseContent.from(Map<String, dynamic> row): _entry = SchemaEntry.empty() {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, FieldValue(value));
    }
  }
  //
  //
  EntryPurchaseContent.empty(): _entry = SchemaEntry.empty() {
	    _entry.update('id', FieldValue(null));
	    _entry.update('purchase_id', FieldValue(null));
	    _entry.update('product_id', FieldValue(null));
	    _entry.update('sale_price', FieldValue('0.00'));
	    _entry.update('sale_currency', FieldValue(''));
	    _entry.update('shipping', FieldValue('0.00'));
	    _entry.update('amount', FieldValue('0.00'));
	    _entry.update('name', FieldValue(''));
	    _entry.update('details', FieldValue(''));
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
