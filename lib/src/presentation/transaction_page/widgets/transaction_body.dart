import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_transaction.dart';
import 'package:flowers_admin/src/infrostructure/transaction/transaction_sqls.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/transaction_page/widgets/add_transaction_form.dart';
import 'package:flowers_admin/src/presentation/transaction_page/widgets/edit_transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
///
///
class TransactionBody extends StatefulWidget {
  final String _authToken;
  ///
  ///
  const TransactionBody({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<TransactionBody> createState() => _TransactionBodyState(
    authToken: _authToken,
  );
}
///
///
class _TransactionBodyState extends State<TransactionBody> {
  late final Log _log;
  final String _authToken;
  final _database = 'flowers_app_server';
  final _apiAddress = const ApiAddress(host: '127.0.0.1', port: 8080);
  ///
  ///
  _TransactionBodyState({
    required String authToken,
  }):
    _authToken = authToken {
      _log = Log("$runtimeType");
    }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return TableWidget<EntryTransaction, void>(
      addAction: TableWidgetAction(
        onPressed: (schema) {
          return showDialog<Result<EntryTransaction, void>?>(
            context: context, 
            builder: (_) => AddTransactionForm(fields: schema.fields,),
          ).then((result) {
            _log.debug('.build | new entry: $result');
            return switch (result) {
              Ok(:final value) => Ok(value),
              Err(:final error) => Err(error),
              _ => const Err(null),
            };
          });
        }, 
        icon: const Icon(Icons.add),
      ),
      editAction: TableWidgetAction(
        onPressed: (schema) {
          final toBeUpdated = schema.entries.where((e) => e.isSelected).toList();
          return showDialog<Result<EntryTransaction, void>?>(
            context: context, 
            builder: (_) => EditTransactionForm(fields: schema.fields, entry: toBeUpdated.lastOrNull, relations: schema.relations),
          ).then((result) {
            _log.debug('.build | edited entry: $result');
            return switch (result) {
              Ok(:final value) => Ok(value),
              Err(:final error) => Err(error),
              _ => const Err(null),
            };
          });
        }, 
        icon: const Icon(Icons.add),
      ),      
      delAction: TableWidgetAction(
        onPressed: (schema) {
          final toBeDeleted = schema.entries.firstWhereOrNull((e) {
            return e.isSelected;
          });
          if (toBeDeleted != null) {
            return showConfirmDialog(
              context, 
              const Text('Delete Product'), 
              Text('Are you sure want to delete following:\n$toBeDeleted'),
            ).then((value) {
              return switch (value) {
                Ok() => Ok(toBeDeleted),
                Err(:final error) => Err(error),
              };
            });
          }
          return Future.value(const Err(null));
        },
        icon: const Icon(Icons.add),
      ),
        schema: RelationSchema<EntryTransaction, void>(
          schema: TableSchema<EntryTransaction, void>(
            read: SqlRead<EntryTransaction, void>(
              address: _apiAddress, 
              authToken: _authToken, 
              database: _database, 
              sqlBuilder: (sql, params) {
                return Sql(sql: 'select * from transaction order by id;');
              },
              entryBuilder: (row) => EntryTransaction.from(row.cast()),
              debug: true,
            ),
            write: SqlWrite<EntryTransaction>(
              address: _apiAddress, 
              authToken: _authToken, 
              database: _database, 
              emptyEntryBuilder: EntryTransaction.empty,
              debug: true,
              updateSqlBuilder: updateSqlBuilderTransaction,
              insertSqlBuilder: insertSqlBuilderTransaction,
              // deleteSqlBuilder: 
            ),
            fields: [
              const Field(hidden: false, editable: false, key: 'id'),
              Field(hidden: false, editable: false, title: '${InRu('Author')}', key: 'author_id', relation: const Relation(id: 'author_id', field: 'name')),
              Field(hidden: false, editable: true, title: '${InRu('Value')}', key: 'value'),
              Field(hidden: false, editable: true, title: '${InRu('TransactionDetails')}', key: 'details'),
              const Field(hidden: true, editable: true, key: 'order_id'),
              Field(hidden: false, editable: false, title: '${InRu('Customer')}', key: 'customer_id', relation: const Relation(id: 'customer_id', field: 'name')),
              Field(hidden: false, editable: false, title: '${InRu('CustomerAccountBefore')}', key: 'customer_account'),
              Field(hidden: false, editable: true, title: '${InRu('Description')}', key: 'description'),
              Field(hidden: false, editable: false, title: '${InRu('Created')}', key: 'created'),
              const Field(hidden: true, editable: false, key: 'updated'),
              const Field(hidden: true, editable: false, key: 'deleted'),
            ],
          ),
          relations: {
            'customer_id': TableSchema<EntryCustomer, void>(
              read: SqlRead<EntryCustomer, void>(
                address: _apiAddress, 
                authToken: _authToken, 
                database: _database, 
                sqlBuilder: (sql, params) {
                  return Sql(sql: 'select id, name from customer order by id;');
                },
                entryBuilder: (row) => EntryCustomer.from(row.cast()),
                debug: true,
              ),
              fields: [
                const Field(key: 'id'),
                const Field(key: 'name'),
              ],
            ),
            'author_id': TableSchema<EntryCustomer, void>(
              read: SqlRead<EntryCustomer, void>(
                address: _apiAddress, 
                authToken: _authToken, 
                database: _database, 
                sqlBuilder: (sql, params) {
                  return Sql(sql: 'select id, name from customer order by id;');
                },
                entryBuilder: (row) => EntryCustomer.from(row.cast()),
                debug: true,
              ),
              fields: [
                const Field(key: 'id'),
                const Field(key: 'name'),
              ],
            ),
          },                  
        ),
    );
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
