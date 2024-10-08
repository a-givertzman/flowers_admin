import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer_order.dart';
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
class PaymentBody extends StatefulWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const PaymentBody({
    super.key,
    required String authToken,
    required AppUser user,
  }):
    _authToken = authToken,
    _user = user;
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<PaymentBody> createState() => _PaymentBodyState(
    authToken: _authToken,
    user: _user,
  );
}
///
///
class _PaymentBodyState extends State<PaymentBody> {
  late final Log _log;
  final String _authToken;
  final AppUser _user;
  final _database = 'flowers_app_server';
  final _apiAddress = const ApiAddress(host: '127.0.0.1', port: 8080);
  ///
  ///
  _PaymentBodyState({
    required String authToken,
    required AppUser user,
  }):
    _authToken = authToken,
    _user = user {
      _log = Log("$runtimeType");
    }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final editableAuthor = [AppUserRole.admin].contains(_user.role);
    final editableValue = [AppUserRole.admin].contains(_user.role);
    final editableDetails = [AppUserRole.admin].contains(_user.role);
    return TableWidget<EntryCustomerOrder, void>(
      showDeleted: [AppUserRole.admin].contains(_user.role) ? false : null,
      fetchAction: TableWidgetAction(
        onPressed: (schema) {
          return Future.value(Ok(EntryCustomerOrder.empty()));
        }, 
        icon: const Icon(Icons.add),
      ),
      schema: RelationSchema<EntryCustomerOrder, void>(
        schema: TableSchema<EntryCustomerOrder, void>(
          read: SqlRead<EntryCustomerOrder, void>(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database, 
            sqlBuilder: (sql, params) {
              return Sql(sql: 'select * from customer_order order by id;');
            },
            entryBuilder: (row) => EntryCustomerOrder.from(row.cast()),
            debug: true,
          ),
          write: SqlWrite<EntryCustomerOrder>(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database, 
            emptyEntryBuilder: EntryCustomerOrder.empty,
            debug: true,
          ),
          fields: [
            const Field(hidden: false, editable: false, key: 'id'),
            Field(hidden: false, editable: editableAuthor, title: '${InRu('Author')}', key: 'author_id', relation: const Relation(id: 'author_id', field: 'name')),
            Field(hidden: false, editable: editableValue, title: '${InRu('Value')}', key: 'value'),
            Field(hidden: false, editable: editableDetails, title: '${InRu('TransactionDetails')}', key: 'details'),
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
                return Sql(sql: 'select id, name, account from customer order by id;');
              },
              entryBuilder: (row) => EntryCustomer.from(row.cast()),
              debug: true,
            ),
            fields: [
              const Field(key: 'id'),
              const Field(key: 'name'),
              const Field(key: 'account'),
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
