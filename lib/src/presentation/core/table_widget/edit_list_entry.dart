import 'package:ext_rw/ext_rw.dart';
///
/// Represents a `Map<String, String>` of key-value of specified field in the entries
class EditListEntry {
  final Map<String, String> _entry = const {};
  ///
  /// Creates EditListEntry with [entries]
  EditListEntry({
    required String field,
    required List<SchemaEntryAbstract> entries,
  }) {
    final map = entries.asMap().map((_, entry) {
      return MapEntry('${entry.value('id').value}', '${entry.value(field).value}');
    });
    _entry.addAll(map);
  }
  ///
  /// Creates EditListEntry with empty `entries`
  const EditListEntry.empty();
  ///
  /// Reterns all contained `entry`
  Map<String, String> get entry => _entry;
  ///
  /// Returns `value` from entry by it's [key]
  String value(key) => _entry['$key'] ?? '';
  ///
  /// Returns EditListEntry String retpresentation
  @override
  String toString() {
    return 'EditListEntry { values: $_entry}';
  }
}

