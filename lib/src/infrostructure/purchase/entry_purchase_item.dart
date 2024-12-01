import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "PurchaseItem"
class EntryPurchaseItem implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  final bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
	    'id': FieldValue(null),
	    'purchase_id': FieldValue(null),
	    'product_id': FieldValue(null),
	    'purchase': FieldValue(''),
	    'product': FieldValue(''),
	    'sale_price': FieldValue('0.00'),
	    'sale_currency': FieldValue(''),
	    'shipping': FieldValue('0.00'),
	    'remains': FieldValue('0.00'),
	    'name': FieldValue(''),
	    'details': FieldValue(''),
	    'description': FieldValue(''),
	    'picture': FieldValue(''),
	    'status': FieldValue(''),
	    'created': FieldValue(''),
	    'updated': FieldValue(''),
	    'deleted': FieldValue(''),
    };
    return initial;
  }
  ///
  /// Single row of table "PurchaseItem"
  /// - [keys] - list of field names
  EntryPurchaseItem({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryPurchaseItem.from(Map<String, dynamic> row):
    _entry = SchemaEntry.from(row, def: _initial),
    _isEmpty = false;
  //
  //
  EntryPurchaseItem.empty():
    _entry = SchemaEntry(map: _initial),
    _isEmpty = true;
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
  bool get isEmpty => _isEmpty;
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
  ///
  ///
  static Sql updateSqlBuilder(Sql sql, EntryPurchaseItem entry) {
    return Sql(sql: """UPDATE purchase_item SET (
        id,
        purchase_id,
        product_id,
        sale_price,
        sale_currency,
        shipping,
        remains,
        name,
        details,
        description,
        picture,
        created,
        updated,
        deleted
      ) = (
        ${entry.value('id').str},
        ${entry.value('purchase_id').str},
        ${entry.value('product_id').str},
        ${entry.value('sale_price').str},
        ${entry.value('sale_currency').str},
        ${entry.value('shipping').str},
        ${entry.value('remains').str},
        ${entry.value('name').str},
        ${entry.value('details').str},
        ${entry.value('description').str},
        ${entry.value('picture').str},
        ${entry.value('created').str},
        ${entry.value('updated').str},
        ${entry.value('deleted').str}
      )
      WHERE id = ${entry.value('id').str};
    """);
  }
}
