import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_log.dart';

///
/// Single row of table "Purchase"
class EntryPurchase implements SchemaEntryAbstract {
  static final Log _log = Log('EntryPurchase');

  final SchemaEntry _entry;
  bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
	    'id': FieldValue(null),
	    'name': FieldValue(''),
	    'details': FieldValue(''),
	    'preview': FieldValue(''),        // used to list some key items of the purchase
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
  EntryPurchase({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryPurchase.from(Map<String, dynamic> row):
    _entry = SchemaEntry.from(row, def: _initial),
    _isEmpty = false;
  //
  //
  EntryPurchase.empty():
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
  /// Returns null if all validators being passed
  String? get isValid {
    final start = DateTime.tryParse('${_entry.value('date_of_start').value}');
    final end = DateTime.tryParse('${_entry.value('date_of_end').value}');
    _log.trace('.isValid | start: $start');
    _log.trace('.isValid |   end: $end');
    if (start == null) return 'Date of start can\'t be empty';
    if (end == null) return 'Date of end can\'t be empty';
    _log.trace('.isValid | compare: ${start.compareTo(end)}');
    if (start.compareTo(end) >= 0) 'Date of start must be before the end date';
    return null;
  }

  ///
  ///
  static Sql updateSqlBuilder(Sql sql, EntryPurchase entry) {
    return Sql(sql: """UPDATE public.purchase SET (
        id,
        name,
        details,
        preview,
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
        ${entry.value('preview').str},
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
  ///
  /// Insert SQL
  static Sql insertSqlBuilder(Sql sql, EntryPurchase entry) {
    return Sql(sql: """insert into public.purchase (
        name,
        details,
        preview,
        status,
        date_of_start,
        date_of_end,
        description,
        picture
      ) values (
        ${entry.value('name').str},
        ${entry.value('details').str},
        ${entry.value('preview').str},
        ${entry.value('status').str},
        ${entry.value('date_of_start').str},
        ${entry.value('date_of_end').str},
        ${entry.value('description').str},
        ${entry.value('picture').str}
      );""",
    );
  }
  ///
  /// Returns delete CUSTOMER Sql 
  static Sql deleteSqlBuilder(Sql sql, EntryPurchase entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      return Sql(sql: "update public.purchase set deleted = CURRENT_TIMESTAMP WHERE id = ${entry.value('id').str};");
    }
  }
}
