import 'package:flowers_admin/src/infrostructure/schames/field.dart';

///
/// abstruction on the SQL table single row
abstract class SchemeEntry {
  ///
  /// Creates entry from database row
  SchemeEntry.from(Map<String, dynamic> row);
  ///
  /// Returns inner unique identificator of the entry, not related to the database table
  String get key;
  ///
  /// Returns field value by field name [key]
  Field value(String key);
  ///
  /// Updates field value by field name [key]
  void update(String key, String value);
}