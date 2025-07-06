import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
/// A collection of the SchameEntry, abstruction on the SQL table rows
/// - Provides a callback [onReady] called when fetch done 
class TableSchemaReady<T extends SchemaEntryAbstract, P> implements TableSchemaAbstract<T, P> {
  late final Log _log;
  final TableSchemaAbstract<T, P> _schema;
  final void Function(Result<Map<String, T>, Failure>) _onReady;
  ///
  /// A collection of the SchameEntry, abstruction on the SQL table rows
  /// - Provides a callback [onReady] called when fetch done 
  TableSchemaReady({
    required TableSchemaAbstract<T, P> schema,
    required void Function(Result<Map<String, T>, Failure>) onReady,
  }) :
    _schema = schema,
    _onReady = onReady {
    _log = Log("$runtimeType"); //..level = LogLevel.info;
  }
  ///
  /// Returns a list of table field names
  @override
  List<Field<T>> get fields {
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
  Map<String, T> get entries => _schema.entries;
  ///
  /// Fetchs data with new sql built from [values]
  @override
  Future<Result<List<T>, Failure>> fetch(P? params) async {
    _log.warning('.fetch | ...');
    late final Result<Map<String, T>, Failure> r;
    return _schema.fetch(params).then(
      (result) {
        switch (result) {
          case Ok<List<T>, Failure>():
            r = Ok(_schema.entries);
          case Err<List<T>, Failure>(: final error):
            r = Err(Failure.pass('$runtimeType.fetch', error));
        }
        return result;
      },
      onError: (err) {
        return Err<List<T>, Failure>(
          Failure.pass('$runtimeType.fetch', err),
        );
      },
    )
    .whenComplete(() {
      _onReady(r);
    });
  }
  //
  //
  @override
  // TODO: implement stream
  Stream<Result<List<T>, Failure>> get stream => throw UnimplementedError();
  ///
  /// Inserts new entry into the table schema
  @override
  Future<Result<void, Failure>> insert({T? entry}) {
    return _schema.insert(entry: entry);
  }
  ///
  /// Updates entry of the table schema
  @override
  Future<Result<void, Failure>> update(T entry) {
    return _schema.update(entry);
  }
  ///
  /// Deletes entry of the table schema
  @override
  Future<Result<void, Failure>> delete(T entry) {
    return _schema.delete(entry);
  }
  //
  //
  @override
  Future<Result<void, Failure>> fetchRelations() {
    return Future.value(
      Err(Failure('$runtimeType.fetchRelations | method does not exists')),
    );
  }
  //
  //
  @override
  Map<String, List<SchemaEntryAbstract>> get relations => _schema.relations;
  //
  //
  @override
  Result<TableSchemaAbstract<SchemaEntryAbstract, dynamic>, Failure> relation(String id) {
    return _schema.relation(id);
  }
  //
  //
  @override
  Future<void> close() {
    return _schema.close();
  }
}
