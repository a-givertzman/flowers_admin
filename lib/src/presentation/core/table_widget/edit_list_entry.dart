import 'package:ext_rw/ext_rw.dart';

///
///
class EditListEntry {
  late final Map<String, String> _values;
  EditListEntry({
    required String field,
    required List<SchemaEntryAbstract> entries,
  }) {
    _values = entries.asMap().map((_, entry) {
      return MapEntry('${entry.value('id').value}', '${entry.value(field).value}');
    });
  }
  EditListEntry.empty() :
    _values = const {};
  Map<String, String> get values => _values;
  String value(id) => _values['$id'] ?? '';
  ///
  ///
  @override
  String toString() {
    return 'TCellEntry { values: $_values}';
  }
}

