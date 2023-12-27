import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "CustomerOredr"
class EntryCustomerOrder implements SchemaEntryAbstract {
  static final _initial = {
      'id': FieldValue(null),
      'customer_id': FieldValue(null),
      'purchase_content_id': FieldValue(null),
      'count': FieldValue('0'),
      'paid': FieldValue('0.0'),
      'distributed': FieldValue('0'),
      'to_refound': FieldValue('0.0'),
      'refounded': FieldValue('0.0'),
      'description': FieldValue(''),
      'created': FieldValue(''),
      'updated': FieldValue(''),
      'deleted': FieldValue(''),
  };
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
  EntryCustomerOrder.from(Map<String, dynamic> row): _entry = SchemaEntry(map: Map.from(_initial)) {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryCustomerOrder.empty(): _entry = SchemaEntry(map: Map.from(_initial));
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
