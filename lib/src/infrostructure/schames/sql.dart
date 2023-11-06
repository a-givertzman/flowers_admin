import 'package:flowers_admin/src/infrostructure/schames/scheme_entry.dart';

///
/// - hosds simple SQL
/// - alows to build sql with multiple values
class Sql {
  ///
  final String _sql;
  List<SchemeEntry> _values;
  ///
  Sql({
    required String sql,
    List<SchemeEntry> values = const [],
  }) :
    _sql = sql,
    _values = values;
  ///
  /// adding values to the sql
  void addValues(SchemeEntry entry) {
    _values.add(entry);
  }
  /// 
  ///
  String build() {
    return _sql;
  }
}