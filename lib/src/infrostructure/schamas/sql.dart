import 'package:flowers_admin/src/infrostructure/schamas/schema_entry.dart';

///
/// - hosds simple SQL
/// - alows to build sql with multiple values
class Sql {
  ///
  final String _sql;
  List<SchemaEntry> _values;
  ///
  Sql({
    required String sql,
    List<SchemaEntry> values = const [],
  }) :
    _sql = sql,
    _values = values;
  ///
  /// adding values to the sql
  void addValues(SchemaEntry entry) {
    _values.add(entry);
  }
  /// 
  ///
  String build() {
    return _sql;
  }
}