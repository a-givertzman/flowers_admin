import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class CustomerOrderBody extends StatefulWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const CustomerOrderBody({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<CustomerOrderBody> createState() => _CustomerOrderBodyState(
    authToken: authToken,
  );
}
//
//
class _CustomerOrderBodyState extends State<CustomerOrderBody> {
  late final Log _log;
  final String _authToken;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final RelationSchema<EntryCustomerOrder, void> _schema;
  //
  //
  _CustomerOrderBodyState({
    required String authToken,
  }):
    _authToken = authToken {
      _log = Log("$runtimeType");
    }
  //
  //
  @override
  void initState() {
    _buildSchema();
    super.initState();
  }
  ///
  /// Returns TableSchema
  _buildSchema() {
    _schema = RelationSchema<EntryCustomerOrder, void>(
      schema: TableSchema<EntryCustomerOrder, void>(
        read: SqlRead<EntryCustomerOrder, void>.keep(
          address: _apiAddress,
          authToken: _authToken,
          database: _database,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select * from customer_order_view order by id;');
          },
          entryBuilder: (row) => EntryCustomerOrder.from(row),
          debug: true,
        ),
        write: SqlWrite<EntryCustomerOrder>.keep(
          address: _apiAddress,
          authToken: _authToken,
          database: _database,
          updateSqlBuilder: EntryCustomerOrder.updateSqlBuilder,
          // insertSqlBuilder: insertSqlBuilderCustomerOrder,
          emptyEntryBuilder: EntryCustomerOrder.empty,
          debug: true,
        ),
        fields: [
          const Field(hidden: false, editable: false, key: 'id'),
                Field(hidden: false, editable: false, title: 'Customer'.inRu, key: 'customer_id', relation: Relation(id: 'customer_id', field: 'name')),
          // const Field(hidden: false, editable: false, key: 'customer'),
                Field(hidden: false, editable: true, key: 'purchase_item_id'),
                Field(hidden: false, editable: true, title: 'Purchase'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'purchase')),
                Field(hidden: false, editable: true, title: 'Product'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'product')),
          // const Field(hidden: false, editable: true, key: 'purchase'),
          // const Field(hidden: false, editable: true, key: 'product'),
                Field(hidden: false, editable: true, title: 'Count'.inRu, key: 'count'),
                Field(hidden: false, editable: true, title: 'Cost'.inRu, key: 'cost'),
                Field(hidden: false, editable: true, title: 'Paid'.inRu, key: 'paid'),
                Field(hidden: false, editable: true, title: 'Distributed'.inRu, key: 'distributed'),
                Field(hidden: false, editable: true, title: 'To refound'.inRu, key: 'to_refound'),
                Field(hidden: false, editable: true, title: 'Refounded'.inRu, key: 'refounded'),
                Field(hidden: false, editable: true, title: 'Description'.inRu, key: 'description'),
          const Field(hidden: true, editable: true, key: 'created'),
          const Field(hidden: true, editable: true, key: 'updated'),
          const Field(hidden: true, editable: true, key: 'deleted'),
        ],
      ),
      relations: _buildRelations(),
    );
  }
  ///
  /// Returns TableSchema
  Map<String, TableSchemaAbstract<SchemaEntryAbstract, dynamic>> _buildRelations() {
    return {
      'customer_id': TableSchema<EntryCustomer, void>(
        read: SqlRead<EntryCustomer, void>.keep(
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
        read: SqlRead<EntryPurchaseItem, void>.keep(
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
    };
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
