import 'package:ext_rw/ext_rw.dart';
///
/// Single row of table "CustomerOredr"
class EntryCustomerOrder implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  final bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
      'id': FieldValue(null),
      'customer_id': FieldValue(null),
      'purchase_item_id': FieldValue(null),
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
    return initial;
  }
  ///
  /// Single row of table "CustomerOrder"
  /// - [keys] - list of field names
  EntryCustomerOrder({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryCustomerOrder.from(Map<String, dynamic> row):
    _entry = SchemaEntry(map: _initial),
    _isEmpty = false {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryCustomerOrder.empty():
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
  static Sql updateSqlBuilder(Sql sql, EntryCustomerOrder entry) {
    return Sql(sql: """UPDATE customer_order SET (
      id,
      customer_id,
      purchase_item_id,
      count,
      paid,
      distributed,
      to_refound,
      refounded,
      description
    ) = (
      ${entry.value('id').str},
      ${entry.value('customer_id').str},
      ${entry.value('purchase_item_id').str},
      ${entry.value('count').str},
      ${entry.value('paid').str},
      ${entry.value('distributed').str},
      ${entry.value('to_refound').str},
      ${entry.value('refounded').str},
      ${entry.value('description').str}
    )
    WHERE id = ${entry.value('id').str};
  """);
  }
  // ///
  // ///
  // Sql updateSqlBuilder(Sql sql, SchemaEntry entry) {
  //   return Sql(sql: """UPDATE _____ SET (
  //   ) = (
  //     '${entry.value('')}'
  //   )
  //   WHERE id = ${entry.value('id')};
  // """);
  // }
}
