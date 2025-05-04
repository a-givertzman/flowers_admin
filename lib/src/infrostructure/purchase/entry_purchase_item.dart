import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "PurchaseItem"
class EntryPurchaseItem implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
	    'id': FieldValue(null),
	    'purchase_id': FieldValue(null),
	    'status': FieldValue(''),
	    'product_id': FieldValue(null),
	    'purchase': FieldValue(''),
	    'product': FieldValue(''),
	    'sale_price': FieldValue('0.00'),
	    'sale_currency': FieldValue(''),
	    'shipping': FieldValue('0.00'),
	    'remains': FieldValue('0'),
	    'name': FieldValue(''),
	    'details': FieldValue(''),
	    'description': FieldValue(''),
	    'picture': FieldValue(''),
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
  void update(String key, dynamic value) {
    _entry.update(key, value);
    _isEmpty = false;
  }
  //
  //
  @override
  void select(bool selected) => _entry.select(selected);
  //
  //
  @override
  void selectionChanged(Function(bool isSelected) onChanged) {
    _entry.selectionChanged(onChanged);
  }
  //
  //
  @override
  void saved() => _entry.saved();
  //
  //
  @override
  String toString() => _entry.toString();
  ///
  /// Returns true if all validators being passed
  String? get isValid {
    if (_isNullOrEmpty('purchase_id')) return 'Purchase can\'t be empty';
    // if (_isNullOrEmpty('status')) return 'Status can\'t be empty';
    if (_isNullOrEmpty('product') && _isNullOrEmpty('product_id')) return 'Product can\'t be empty';
    if (_isNullOrEmpty('sale_currency')) return 'Currency can\'t be empty';
    return null;
  }
  ///
  /// Returns true if value null or empty
  bool _isNullOrEmpty(String key) {
    if (_entry.value(key).value == null) return true;
    if ('${_entry.value(key).value}'.isEmpty) return true;
    if ('${_entry.value(key).value}' == "''") return true;
    if ('${_entry.value(key).value}' == 'null') return true;
    if ('${_entry.value(key).value}' == "'null'") return true;
    return false;
  }
  /// - if val is null  => 'null'
  /// - if val is empty => 'null'
  /// - otherwise       => 'val'
  static String _nullIfEmpty(dynamic val) {
    return (val == null) ? 'null' : ('$val'.isEmpty) ? 'null' : "'$val'";
  }
  ///
  ///
  static Sql updateSqlBuilder(Sql sql, EntryPurchaseItem entry) {
    final m = {
      if (entry.value('purchase_id').isChanged) ...{'purchase_id': entry.value('purchase_id').str},
      if (entry.value('status').isChanged) ...{'status': _nullIfEmpty(entry.value('status').value)},
      if (entry.value('product_id').isChanged) ...{'product_id': entry.value('product_id').str},
      if (entry.value('sale_price').isChanged) ...{'sale_price': entry.value('sale_price').str},
      if (entry.value('sale_currency').isChanged) ...{'sale_currency': entry.value('sale_currency').str},
      if (entry.value('shipping').isChanged) ...{'shipping': entry.value('shipping').str},
      if (entry.value('remains').isChanged) ...{'remains': entry.value('remains').str},
      if (entry.value('name').isChanged) ...{'name': _nullIfEmpty(entry.value('product').value)},
      if (entry.value('details').isChanged) ...{'details': _nullIfEmpty(entry.value('details').value)},
      if (entry.value('description').isChanged) ...{'description': _nullIfEmpty(entry.value('description').value)},
      if (entry.value('picture').isChanged) ...{'picture': _nullIfEmpty(entry.value('picture').value)},
      if (entry.value('deleted').isChanged) ...{'deleted': entry.value('deleted').str},
    };
    final keys = m.keys.toList().join(',');
    final values = m.values.toList().join(',');
    if (m.length > 1) {
      return Sql(sql: """UPDATE public.purchase_item SET (
          $keys
        ) = (
          $values
        )
        WHERE id = ${entry.value('id').str};
      """);
    }
    return Sql(sql: """UPDATE public.purchase_item SET $keys = $values
      WHERE id = ${entry.value('id').str};
    """);
  }
  ///
  ///
  static Sql insertSqlBuilder(Sql sql, EntryPurchaseItem entry) {
    return Sql(sql: """insert into public.purchase_item (
        purchase_id,
        product_id,
        sale_price,
        sale_currency,
        shipping,
        remains,
        name,
        details,
        description,
        picture
      ) values (
        ${entry.value('purchase_id').str},
        ${entry.value('product_id').str},
        ${entry.value('sale_price').str},
        ${entry.value('sale_currency').str},
        ${entry.value('shipping').str},
        ${entry.value('remains').str},
        ${entry.value('name').str},
        ${entry.value('details').str},
        ${entry.value('description').str},
        ${entry.value('picture').str}
      );""",
    );
  }
}
