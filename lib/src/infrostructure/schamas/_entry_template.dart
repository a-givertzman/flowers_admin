import 'package:ext_rw/ext_rw.dart';

///
/// Single row of table "Customer"
class EntryTemplate implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
      'id': FieldValue(null),
      '...': FieldValue(null),
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
  /// Single row of table "Template"
  /// - [keys] - list of field names
  EntryTemplate({
    required Map<String, FieldValue> map,
  }) :
    _entry = SchemaEntry(map: map);
  //
  //
  @override
  EntryTemplate.from(Map<String, dynamic> row): _entry = SchemaEntry(map: _initial) {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
  //
  //
  EntryTemplate.empty(): _entry = SchemaEntry(map: _initial);
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
