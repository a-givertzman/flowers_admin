import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Purchase"
class EntryPayPurchase implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
      'pay': FieldValue(false),
	    'id': FieldValue(null),
	    'name': FieldValue(''),
	    'details': FieldValue(''),
	    'preview': FieldValue(''),
	    'status': FieldValue(''),
	    'date_of_start': FieldValue(''),
	    'date_of_end': FieldValue(''),
	    'description': FieldValue(''),
	    'picture': FieldValue(''),
	    'created': FieldValue(''),
	    'updated': FieldValue(''),
	    'deleted': FieldValue(''),
    };
    return initial;
  }
  ///
  /// Single row of table "Purchase"
  /// - [keys] - list of field names
  EntryPayPurchase({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryPayPurchase.from(Map<String, dynamic> row):
    _entry = SchemaEntry.from(row, def: _initial),
    _isEmpty = false;
  //
  //
  EntryPayPurchase.empty():
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
  ///
  static Sql updateSqlBuilder(Sql sql, EntryPayPurchase entry) {
    return Sql(sql: """UPDATE purchase SET (
        id,
        name,
        details,
        status,
        date_of_start,
        date_of_end,
        description,
        picture,
        created,
        updated,
        deleted
      ) = (
        ${entry.value('id').str},
        ${entry.value('name').str},
        ${entry.value('details').str},
        ${entry.value('status').str},
        ${entry.value('date_of_start').str},
        ${entry.value('date_of_end').str},
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
