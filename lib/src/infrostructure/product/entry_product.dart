import 'package:ext_rw/ext_rw.dart';
///
/// Single row of table "Product"
class EntryProduct implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  final bool _isEmpty;
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
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryProduct.from(Map<String, dynamic> row):
    _entry = SchemaEntry(map: _initial),
    _isEmpty = false {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryProduct.empty():
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
  static Sql updateSqlBuilder(Sql sql, EntryProduct entry) {
    final m = {
      if (entry.value('id').isChanged) ...{'id': entry.value('id').str},
      if (entry.value('product_category_id').isChanged) ...{'product_category_id': entry.value('product_category_id').str},
      if (entry.value('name').isChanged) ...{'name': entry.value('name').str},
      if (entry.value('details').isChanged) ...{'details': entry.value('details').str},
      if (entry.value('primary_price').isChanged) ...{'primary_price': entry.value('primary_price').str},
      if (entry.value('primary_currency').isChanged) ...{'primary_currency': entry.value('primary_currency').str},
      if (entry.value('primary_order_quantity').isChanged) ...{'primary_order_quantity': entry.value('primary_order_quantity').str},
      if (entry.value('order_quantity').isChanged) ...{'order_quantity': entry.value('order_quantity').str},
      if (entry.value('description').isChanged) ...{'description': entry.value('description').str},
      if (entry.value('picture').isChanged) ...{'picture': entry.value('picture').str},
      if (entry.value('deleted').isChanged) ...{'deleted': entry.value('deleted').str},
    };
    final keys = m.keys.toList().join(',');
    final values = m.values.toList().join(',');
    return Sql(sql: """UPDATE product SET (
      $keys
    ) = (
      $values
    )
    WHERE id = ${entry.value('id').str};
  """);
  }
}







// ///
// /// === ORIGINAL ===
// Sql updateSqlBuilderProduct(Sql sql, EntryProduct entry) {
//   return Sql(sql: """UPDATE product SET (
//     id,
//     product_category_id,
//     name,
//     details,
//     primary_price,
//     primary_currency,
//     primary_order_quantity,
//     order_quantity,
//     description,
//     picture,
//     created,
//     updated,
//     deleted
//   ) = (
//     ${entry.value('id').str},
//     ${entry.value('product_category_id').str},
//     ${entry.value('name').str},
//     ${entry.value('details').str},
//     ${entry.value('primary_price').str},
//     ${entry.value('primary_currency').str},
//     ${entry.value('primary_order_quantity').str},
//     ${entry.value('order_quantity').str},
//     ${entry.value('description').str},
//     ${entry.value('picture').str},
//     ${entry.value('created').str},
//     ${entry.value('updated').str},
//     ${entry.value('deleted').str}
//   )
//   WHERE id = ${entry.value('id').str};
// """);
// }
