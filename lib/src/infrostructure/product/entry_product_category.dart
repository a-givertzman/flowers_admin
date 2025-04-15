import 'package:ext_rw/ext_rw.dart';
///
/// Single row of table "ProductCategory"
class EntryProductCategory implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  final bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
      'id': FieldValue(0),
      'category_id': FieldValue(0),
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
  /// Single row of table "ProductCategory"
  /// - [keys] - list of field names
  EntryProductCategory({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryProductCategory.from(Map<String, dynamic> row):
    _entry = SchemaEntry.from(row, def: _initial),
    _isEmpty = false;
  //
  //
  EntryProductCategory.empty():
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
  static Sql updateSqlBuilder(Sql sql, EntryProductCategory entry) {
    return Sql(sql: """UPDATE product_category SET (
      id,
      category_id,
      name,
      details,
      description,
      picture,
      created,
      updated,
      deleted
    ) = (
      ${entry.value('id').str},
      ${entry.value('category_id').str},
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
  ///
  ///
  static Sql insertSqlBuilder(Sql sql, EntryProductCategory entry) {
    return Sql(sql: """insert into product_category (
      category_id,
      name,
      details,
      description,
      picture
    ) values (
      ${entry.value('category_id').str},
      ${entry.value('name').str},
      ${entry.value('details').str},
      ${entry.value('description').str},
      ${entry.value('picture').str}
    );
    """);
  }
  ///
  /// Returns delete CUSTOMER Sql 
  static Sql deleteSqlBuilder(Sql sql, EntryProductCategory entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      return Sql(sql: "update product_category set deleted = CURRENT_TIMESTAMP WHERE id = ${entry.value('id').str};");
    }
  }
}
