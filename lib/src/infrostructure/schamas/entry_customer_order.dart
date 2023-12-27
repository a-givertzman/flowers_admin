import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "CustomerOredr"
class EntryCustomerOrder implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  ///
  /// Single row of table "CustomerOrder"
  /// - [keys] - list of field names
  EntryCustomerOrder({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  @override
  EntryCustomerOrder.from(Map<String, dynamic> row): _entry = SchemaEntry.empty() {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, FieldValue(value));
    }
  }
  //
  //
  EntryCustomerOrder.empty(): _entry = SchemaEntry.empty() {
      _entry.update('id', FieldValue(null));
      _entry.update('customer_id', FieldValue(null));
      _entry.update('purchase_content_id', FieldValue(null));
      _entry.update('count', FieldValue('0'));
      _entry.update('paid', FieldValue('0.0'));
      _entry.update('distributed', FieldValue('0'));
      _entry.update('to_refound', FieldValue('0.0'));
      _entry.update('refounded', FieldValue('0.0'));
      _entry.update('description', FieldValue(''));
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
