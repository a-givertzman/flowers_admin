import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
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
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
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
            keepAlive: true,
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
            keepAlive: true,
            emptyEntryBuilder: EntryCustomerOrder.empty,
            debug: true,
          ),
          fields: [
            const Field(hidden: false, editable: false, key: 'id'),
            const Field(hidden: false, editable: false, key: 'customer_id', relation: Relation(id: 'customer_id', field: 'name')),
            // const Field(hidden: false, editable: false, key: 'customer'),
            const Field(hidden: false, editable: true, key: 'purchase_item_id'),
            const Field(hidden: false, editable: true, title: 'Purchase id', key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'purchase')),
            const Field(hidden: false, editable: true, title: 'Product id', key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'product')),
            // const Field(hidden: false, editable: true, key: 'purchase'),
            // const Field(hidden: false, editable: true, key: 'product'),
            const Field(hidden: false, editable: true, key: 'count'),
            const Field(hidden: false, editable: true, key: 'paid'),
            const Field(hidden: false, editable: true, key: 'distributed'),
            const Field(hidden: false, editable: true, key: 'to_refound'),
            const Field(hidden: false, editable: true, key: 'refounded'),
            const Field(hidden: false, editable: true, key: 'description'),
            const Field(hidden: true, editable: true, key: 'created'),
            const Field(hidden: true, editable: true, key: 'updated'),
            const Field(hidden: true, editable: true, key: 'deleted'),
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
          'purchase_item_id': TableSchema<EntryPurchaseItem, void>(
            read: SqlRead<EntryPurchaseItem, void>(
              address: _apiAddress, 
              authToken: _authToken, 
              database: _database, 
              sqlBuilder: (sql, params) {
                return Sql(sql: 'select id, purchase_id, purchase, product_id, product from purchase_item_view order by id;');
              },
              entryBuilder: (row) => EntryPurchaseItem.from(row),
              debug: true,
            ),
            fields: [
              const Field(key: 'id'),
              const Field(key: 'purchase_id'),
              const Field(key: 'purchase'),
              const Field(key: 'product_id'),
              const Field(key: 'product'),
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
