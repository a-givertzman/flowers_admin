import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/infrostructure/customer/customer_sqls.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_factory.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/customer_page/widgets/edit_customer_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
///
class CustomerBody extends StatefulWidget {
  final String _authToken;
  ///
  ///
  const CustomerBody({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<CustomerBody> createState() => _CustomerBodyState(
    authToken: _authToken,
  );
}
///
///
class _CustomerBodyState extends State<CustomerBody> {
  final _log = Log("$_CustomerBodyState._");
  final String _authToken;
  final _database = 'flowers_app_server';
  final _apiAddress = const ApiAddress(host: '127.0.0.1', port: 8080);
  ///
  ///
  _CustomerBodyState({
    required String authToken,
  }):
    _authToken = authToken;
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return TableWidget<EntryCustomer, void>(
      addAction: TableWidgetAction(
        onPressed: (schema) {
          return showDialog<Result<EntryCustomer, void>?>(
            context: context, 
            builder: (_) => const EditCustomerForm(),
          ).then((result) {
            _log.debug('new entry: $result');
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
          final toBeUpdated = schema.entries.where(
            (e) {
              return e.isSelected;
            },
          ).toList();
          return showDialog<Result<EntryCustomer, void>?>(
            context: context, 
            builder: (_) => EditCustomerForm(entry: toBeUpdated.lastOrNull),
          ).then((result) {
            _log.debug('edited entry: $result');
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
          final toBeDeleted = schema.entries.firstWhere((e) {
            return e.isSelected;
          });
          return showConfirmDialog(
            context, 
            const Text('Delete Customer'), 
            Text('Are you sure want to delete following:\n$toBeDeleted'),
          ).then((value) {
            return switch (value) {
              Ok() => Ok(toBeDeleted),
              Err(:final error) => Err(error),
            };
          });
        },
        icon: const Icon(Icons.add),
      ),
      schema: TableSchema<EntryCustomer, void>(
        read: SqlRead<EntryCustomer, void>(
          address: _apiAddress, 
          authToken: _authToken, 
          database: _database, 
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select * from customer order by id;');
          },
          entryFromFactories: entryFromFactories.cast(),
          debug: true,
        ),
        write: SqlWrite<EntryCustomer>(
          address: _apiAddress, 
          authToken: _authToken, 
          database: _database, 
          updateSqlBuilder: updateSqlBuilderCustomer,
          insertSqlBuilder: insertSqlBuilderCustomer,
          entryFromFactories: entryFromFactories.cast(), 
          entryEmptyFactories: entryEmptyFactories.cast(),
          debug: true,
        ),
        fields: [
          const Field(hidden: false, edit: false, key: 'id'),
          const Field(hidden: false, edit: true, key: 'role'),
          const Field(hidden: false, edit: true, key: 'email'),
          const Field(hidden: false, edit: true, key: 'phone'),
          const Field(hidden: false, edit: true, key: 'name'),
          const Field(hidden: false, edit: true, key: 'location'),
          const Field(hidden: false, edit: true, key: 'login'),
          const Field(hidden: false, edit: true, key: 'pass'),
          const Field(hidden: false, edit: true, key: 'account'),
          const Field(hidden: false, edit: true, key: 'last_act'),
          const Field(hidden: false, edit: true, key: 'blocked'),
          const Field(hidden: true, edit: true, key: 'created'),
          const Field(hidden: true, edit: true, key: 'updated'),
          const Field(hidden: true, edit: true, key: 'deleted'),
        ],
      ),
    );
  }
}


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