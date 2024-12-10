import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class PurchaseItemBody extends StatefulWidget {
  final String _authToken;
  ///
  ///
  const PurchaseItemBody({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<PurchaseItemBody> createState() => _PurchaseItemBodyState(
    authToken: _authToken,
  );
}
//
//
class _PurchaseItemBodyState extends State<PurchaseItemBody> {
  late final Log _log;
  final String _authToken;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final RelationSchema<EntryPurchaseItem, void> _schema;
  //
  //
  _PurchaseItemBodyState({
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
  RelationSchema<EntryPurchaseItem, void> _buildSchema() {
    return RelationSchema<EntryPurchaseItem, void>(
        schema: TableSchema<EntryPurchaseItem, void>(
          read: SqlRead<EntryPurchaseItem, void>(
            address: _apiAddress,
            authToken: _authToken,
            database: _database,
            sqlBuilder: (sql, params) {
              return Sql(sql: 'select * from purchase_item_view order by id;');
            },
            entryBuilder: (row) => EntryPurchaseItem.from(row),
            debug: true,
          ),
          write: SqlWrite<EntryPurchaseItem>(
            address: _apiAddress,
            authToken: _authToken,
            database: _database,
            updateSqlBuilder: EntryPurchaseItem.updateSqlBuilder,
            // insertSqlBuilder: insertSqlBuilderPurchaseItem,
            emptyEntryBuilder: EntryPurchaseItem.empty,
            debug: true,
          ),
          fields: [
            const Field(hidden: false, editable: false, key: 'id'),
            const Field(hidden: false, editable: true, key: 'purchase_id', relation: Relation(id: 'purchase_id', field: 'name')),
            const Field(hidden: false, editable: true, key: 'product_id', relation: Relation(id: 'product_id', field: 'name')),
            const Field(hidden: false, editable: true, key: 'sale_price'),
            const Field(hidden: false, editable: true, key: 'sale_currency'),
            const Field(hidden: false, editable: true, key: 'shipping'),
            const Field(hidden: false, editable: true, key: 'remains'),
            const Field(hidden: false, editable: true, key: 'name'),
            const Field(hidden: false, editable: true, key: 'details'),
            const Field(hidden: false, editable: true, key: 'description'),
            const Field(hidden: false, editable: true, key: 'picture'),
            const Field(hidden: true, editable: true, key: 'created'),
            const Field(hidden: true, editable: true, key: 'updated'),
            const Field(hidden: true, editable: true, key: 'deleted'),
          ],
        ),
        relations: _buildRelations(),
      );
  }
  ///
  /// Returns Relations
  _buildRelations() {
    return {
      'purchase_id': TableSchema<EntryPurchase, void>(
        read: SqlRead<EntryPurchase, void>(
          address: _apiAddress,
          authToken: _authToken,
          database: _database,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select id, name from purchase order by id;');
          },
          entryBuilder: (row) => EntryPurchase.from(row),
          debug: true,
        ),
        fields: [
          const Field(key: 'id'),
          const Field(key: 'name'),
        ],
      ),
      'product_id': TableSchema<EntryProduct, void>(
        read: SqlRead<EntryProduct, void>(
          address: _apiAddress,
          authToken: _authToken,
          database: _database,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select id, name from product order by id;');
          },
          entryBuilder: (row) => EntryProduct.from(row),
          debug: true,
        ),
        fields: [
          const Field(key: 'id'),
          const Field(key: 'name'),
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
      fetchAction: TableWidgetAction(
        onPressed: (schema) {
          return Future.value(Ok(EntryPurchaseItem.empty()));
        }, 
        icon: const Icon(Icons.add),
      ),
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
