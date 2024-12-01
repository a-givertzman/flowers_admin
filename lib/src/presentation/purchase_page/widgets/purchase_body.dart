import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class PurchaseBody extends StatefulWidget {
  final String _authToken;
  ///
  ///
  const PurchaseBody({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<PurchaseBody> createState() => _PurchaseBodyState(
    authToken: _authToken,
  );
}
//
//
class _PurchaseBodyState extends State<PurchaseBody> {
  late final Log _log;
  final String _authToken;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final TableSchema<EntryPurchase, void> _schema;
  //
  //
  _PurchaseBodyState({
    required String authToken,
  }):
    _authToken = authToken {
      _log = Log("$runtimeType");
    }
  //
  //
  @override
  void initState() {
    _schema = _buildSchema();
    super.initState();
  }
  ///
  /// Returns TableSchema
  TableSchema<EntryPurchase, void> _buildSchema() {
    return TableSchema<EntryPurchase, void>(
      read: SqlRead<EntryPurchase, void>(
        address: _apiAddress,
        authToken: _authToken,
        database: _database,
        sqlBuilder: (sql, params) {
          return Sql(sql: 'select * from purchase order by id;');
        },
        entryBuilder: (row) => EntryPurchase.from(row),
        keepAlive: true,
        debug: true,
      ),
      write: SqlWrite<EntryPurchase>(
        address: _apiAddress,
        authToken: _authToken,
        database: _database,
        updateSqlBuilder: EntryPurchase.updateSqlBuilder,
        // insertSqlBuilder: insertSqlBuilderPurchase,
        emptyEntryBuilder: EntryPurchase.empty,
        keepAlive: true,
        debug: true,
      ),
      fields: [
        const Field(hidden: false, editable: false, key: 'id'),
        const Field(hidden: false, editable: true, key: 'name'),
        const Field(hidden: false, editable: true, key: 'details'),
        const Field(hidden: false, editable: true, key: 'status'),
        const Field(hidden: false, editable: true, key: 'date_of_start'),
        const Field(hidden: false, editable: true, key: 'date_of_end'),
        const Field(hidden: false, editable: true, key: 'description'),
        const Field(hidden: false, editable: true, key: 'picture'),
        const Field(hidden: true, editable: true, key: 'created'),
        const Field(hidden: true, editable: true, key: 'updated'),
        const Field(hidden: true, editable: true, key: 'deleted'),
      ],
    );
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    return TableWidget(
      schema: _schema,
    );
  }
  //
  //
  @override
  void dispose() {
    _schema.close();
    super.dispose();
  }
}
///
///
Future<Result<void, void>> showConfirmDialog(BuildContext context, title, content) {
  return showDialog<Result>(
    context: context,
    builder: (_) => AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed:  () {
            Navigator.pop(context, const Err(null));
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed:  () {
            Navigator.pop(context, const Ok(null));
          },
        ),
      ],              
    ),
  ).then((value) => value ?? const Err(null));
}
