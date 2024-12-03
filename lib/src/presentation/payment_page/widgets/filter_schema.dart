import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
/// A collection of the SchameEntry, 
/// abstruction on the SQL table rows
class FilterSchema<T extends SchemaEntryAbstract, P> implements TableSchemaAbstract<T, P> {
  late final Log _log;
  final TableSchemaAbstract<T, P> _schema;
  final bool Function(T) _filter;
  ///
  /// A collection of the SchameEntry, 
  /// abstruction on the SQL table rows
  /// - [keys] - list of table field names
  FilterSchema({
    required TableSchemaAbstract<T, P> schema,
    required bool Function(T entry) filter,
  }) :
    _schema = schema,
    _filter = filter {
    _log = Log("$runtimeType")..level = LogLevel.info;
  }
  ///
  /// Returns a list of table field names
  @override
  List<Field> get fields {
    return _schema.fields;
  }
  ///
  /// Returns a list of table field keys
  @override
  List<String> get keys {
    return _schema.keys;
  }
  //
  //
  @override
  List<T> get entries => _schema.entries;
  ///
  /// Fetchs data with new sql built from [values]
  @override
  Future<Result<List<T>, Failure>> fetch(P? params) async {
    _log.warning('.fetch | ...');
    return _schema.fetch(params).then(
      (result) {
        switch (result) {
          case Ok<List<T>, Failure>(value: final entries):
            final result = entries.where((entry) => _filter(entry)).toList();
            return Ok(result);
          case Err<List<T>, Failure>(: final error):
            return Err<List<T>, Failure>(
              Failure(message: "$runtimeType.fetch | Error: $error", stackTrace: StackTrace.current),
            );
        }
      },
      onError: (err) {
        return Err<List<T>, Failure>(
          Failure(message: "$runtimeType.fetch | Error: $err", stackTrace: StackTrace.current),
        );
      },
    );
  }
  ///
  /// Inserts new entry into the table schema
  @override
  Future<Result<void, Failure>> insert({T? entry}) {
    return _schema.insert(entry: entry);
    // .then((result) {
    //   return switch (result) {
    //     Ok(:final value) => () {
    //       final entry_ = value;
    //       _entries[entry_.key] = entry_;
    //       return const Ok<void, Failure>(null);
    //     }(),
    //     Err(:final error) => Err(error),
    //   };
    // });
  }
  ///
  /// Updates entry of the table schema
  @override
  Future<Result<void, Failure>> update(T entry) {
    return _schema.update(entry);
    // .then((result) {
    //   if (result is Ok) {
    //     entry.saved();
    //     _entries[entry.key] = entry;
    //   }
    //   return result;
    // });
  }
  ///
  /// Deletes entry of the table schema
  @override
  Future<Result<void, Failure>> delete(T entry) {
    return _schema.delete(entry);
    // final write = _write;
    // return write.delete(entry).then((result) {
    //   if (result is Ok) {
    //     _entries.remove(entry.key);
    //   }
    //   return result;
    // });
  }
  //
  //
  @override
  Future<Result<void, Failure>> fetchRelations() {
    return Future.value(
      Err(Failure(
        message: '$runtimeType.fetchRelations | method does not exists', 
        stackTrace: StackTrace.current,
      )),
    );
  }
  //
  //
  @override
  Map<String, List<SchemaEntryAbstract>> get relations {
    return {};
  }
  //
  //
  @override
  Result<FilterSchema<SchemaEntry, dynamic>, Failure> relation(String id) {
    return Err(Failure(
        message: '$runtimeType.relation | method does not exists', 
        stackTrace: StackTrace.current,
    ));
  }
  //
  //
  @override
  Future<void> close() {
    return _schema.close();
  }
}
