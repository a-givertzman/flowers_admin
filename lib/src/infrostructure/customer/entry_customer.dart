import 'package:ext_rw/ext_rw.dart';
// import 'package:hmi_core/hmi_core_log.dart';
///
/// Single row of table "Customer"
class EntryCustomer implements SchemaEntryAbstract {
  // final _log = Log("$EntryCustomer");
  late final SchemaEntry _entry;
  bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
      'id': FieldValue(0),
      'role': FieldValue('guest'),
      'email': FieldValue('@'),
      'phone': FieldValue('+7'),
      'name': FieldValue(''),
      'location': FieldValue(''),
      'login': FieldValue(''),
      'pass': FieldValue(''),
      'account': FieldValue('0'),
      'last_act': FieldValue(null),
      'blocked': FieldValue(null),
      'picture': FieldValue(''),
      'created': FieldValue(null),
      'updated': FieldValue(null),
      'deleted': FieldValue(null),
    };
    return initial;
  }
  ///
  /// Single row of table "Customer"
  /// - [keys] - list of field names
  EntryCustomer({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryCustomer.from(Map<String, dynamic> row):
    _entry = SchemaEntry.from(row, def: _initial),
    _isEmpty = false;
  //
  //
  EntryCustomer.empty(): 
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
  /// CUSTOMER
  static Sql updateSqlBuilder(Sql sql, EntryCustomer entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      final m = {
        if (entry.value('id').isChanged) ...{'id': entry.value('id').str},
        if (entry.value('role').isChanged) ...{'role': entry.value('role').str},
        if (entry.value('email').isChanged) ...{'email': entry.value('email').str},
        if (entry.value('phone').isChanged) ...{'phone': entry.value('phone').str},
        if (entry.value('name').isChanged) ...{'name': entry.value('name').str},
        if (entry.value('location').isChanged) ...{'location': entry.value('location').str},
        if (entry.value('login').isChanged) ...{'login': entry.value('login').str},
        if (entry.value('pass').isChanged) ...{'pass': entry.value('pass').str},
        if (entry.value('account').isChanged) ...{'account': entry.value('account').str},
        if (entry.value('last_act').isChanged) ...{'last_act': entry.value('last_act').str},
        if (entry.value('blocked').isChanged) ...{'blocked': entry.value('blocked').str},
        if (entry.value('picture').isChanged) ...{'picture': entry.value('picture').str},
        if (entry.value('deleted').isChanged) ...{'deleted': entry.value('deleted').str},
      };
      final keys = m.keys.toList().join(',');
      final values = m.values.toList().join(',');
      if (m.length > 1) {
        return Sql(sql: """UPDATE public.customer SET (
            $keys
          ) = (
            $values
          )
          WHERE id = ${entry.value('id').str};
        """);
      }
      return Sql(sql: """UPDATE public.customer SET $keys = $values
        WHERE id = ${entry.value('id').str};
      """);
    }
  }
  ///
  ///
  static Sql insertSqlBuilder(Sql sql, EntryCustomer entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      return Sql(sql: """insert into customer (
          role,
          email,
          phone,
          name,
          location,
          login,
          pass,
          account,
          last_act,
          blocked,
          picture
        ) values (
          ${entry.value('role').str},
          ${entry.value('email').str},
          ${entry.value('phone').str},
          ${entry.value('name').str},
          ${entry.value('location').str},
          ${entry.value('login').str},
          ${entry.value('pass').str},
          ${entry.value('account').str},
          ${entry.value('last_act').str},
          ${entry.value('blocked').str},
          ${entry.value('picture').str}
        );
        """,
      );
    }
  }
  ///
  /// Returns delete CUSTOMER Sql 
  static Sql deleteSqlBuilder(Sql sql, EntryCustomer entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      return Sql(sql: "update public.customer set deleted = CURRENT_TIMESTAMP WHERE id = ${entry.value('id').str};",);
    }
  }
}
