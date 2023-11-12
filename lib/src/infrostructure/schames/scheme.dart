import 'package:dart_api_client/dart_api_client.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_factory.dart';
import 'package:flowers_admin/src/infrostructure/schames/field.dart';
import 'package:flowers_admin/src/infrostructure/schames/scheme_entry.dart';
import 'package:flowers_admin/src/infrostructure/schames/sql.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';

typedef SqlBuilder<T> = Sql Function(Sql sql, SchemeEntry entry);


///
/// A collection of the SchameEntry, 
/// abstruction on the SQL table rows
class Scheme<T extends SchemeEntry> {
  final ApiAddress _address;
  final String _authToken;
  final String _database;
  final bool _keepAlive;
  final bool _debug;
  final List<Field> _fields;
  final Map<String, SchemeEntry> _entries = {};
  final Sql Function(List<dynamic>? values) _fetchSqlBuilder;
  final SqlBuilder? _insertSqlBuilder;
  final SqlBuilder? _updateSqlBuilder;
  // final SchemeEntry Function(Map<String, dynamic> row) _schemeBuilder;
  ///
  /// A collection of the SchameEntry, 
  /// abstruction on the SQL table rows
  /// - [keys] - list of table field names
  Scheme({
    required ApiAddress address,
    required String authToken,
    required String database,
    required List<Field> fields,
    bool keepAlive = false,
    bool debug = false,
    required Sql Function(List<dynamic>? values) fetchSqlBuilder,
    SqlBuilder? insertSqlBuilder,
    SqlBuilder? updateSqlBuilder,
    // required SchemeEntry Function(Map<String, dynamic> row) schemeBuilder,
  }) :
    _address = address,
    _authToken = authToken,
    _database = database,
    _fields = fields,
    _keepAlive = keepAlive,
    _debug = debug,
    _fetchSqlBuilder = fetchSqlBuilder,
    _insertSqlBuilder = insertSqlBuilder,
    _updateSqlBuilder = updateSqlBuilder;
    // _schemeBuilder = schemeBuilder;
  ///
  /// Returns a list of table field names
  List<Field> get fields {
    return _fields;
  }
  ///
  /// Returns a list of table field keys
  List<String> get keys {
    return _fields.map((field) => field.key).toList();
  }
  ///
  ///
  Future<Result<List<SchemeEntry>>> refresh(values) {
    final sql = _fetchSqlBuilder(values);
    return fetchWith(sql);
  }
  ///
  ///
  Future<Result<List<SchemeEntry>>> fetch(values) {
    final sql = _fetchSqlBuilder(values);
    return fetchWith(sql);
  }
  ///
  T _makeEntry(Map<String, dynamic> row) {
    final constructor = entryFactories[T];
    if (constructor != null) {
      return constructor(row);
    }
    throw Failure(
      message: "$runtimeType._makeEntry | Can't find constructor for $T", 
      stackTrace: StackTrace.current,
    );
  }
  ///
  ///
  Future<Result<List<SchemeEntry>>> fetchWith(Sql sql) {
    final request = ApiRequest(
      address: _address, 
      query: SqlQuery(
        authToken: _authToken, 
        database: _database,
        sql: sql.build(),
        keepAlive: _keepAlive,
        debug: _debug,
      ),
    );
    return request.fetch().then((result) {
      return result.fold(
        onData: (replay) {
          if (replay.hasError) {
            return Result(error: Failure(message: replay.error.message, stackTrace: StackTrace.current));
          } else {
            _entries.clear();
            final rows = replay.data;
            for (final row in rows) {
              final entry = _makeEntry(row);
              if (_entries.containsKey(entry.key)) {
                throw Failure(
                  message: "$runtimeType.fetchWith | dublicated entry key: ${entry.key}", 
                  stackTrace: StackTrace.current,
                );
              }
              _entries[entry.key] = entry;
            }
          }
          return Result(data: _entries.values.toList());
        }, 
        onError: (err) {
          return Result(error: err);
        },
      );
    });
  }
  ///
  /// Inserts new entry into the table scheme
  Future<Result<void>> insert(SchemeEntry entry) {
    final builder = _insertSqlBuilder;
    if (builder != null) {
      final initialSql = Sql(sql: '');
      final sql = builder(initialSql, entry);
      return fetchWith(sql).then((result) {
        if (!result.hasError) {
          _entries[entry.key] = entry;
        }
        return result;
      });
    }
    throw Failure(
      message: "$runtimeType.insert | insertSqlBuilder is not initialized", 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// Updates entry of the table scheme
  Future<Result<void>> update(SchemeEntry entry) {
    final builder = _updateSqlBuilder;
    if (builder != null) {
      final initialSql = Sql(sql: '');
      final sql = builder(initialSql, entry);
      return fetchWith(sql).then((result) {
        if (!result.hasError) {
          _entries[entry.key] = entry;
        }
        return result;
      });
    }
    throw Failure(
      message: "$runtimeType.update | updateSqlBuilder is not initialized", 
      stackTrace: StackTrace.current,
    );
  }
}