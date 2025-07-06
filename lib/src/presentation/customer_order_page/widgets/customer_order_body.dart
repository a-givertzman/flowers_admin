import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/presentation/core/form_widget/edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/customer_order_page/widgets/edit_customer_order_form.dart';
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
  String _customerId = '';
  String _purchaseId = '';
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
            if (_customerId.isNotEmpty && _purchaseId.isNotEmpty) {
              return Sql(sql: 'select * from customer_order_view where customer_id = $_customerId and purchase_id = $_purchaseId order by id;');
            } else if (_customerId.isNotEmpty) {
              return Sql(sql: 'select * from customer_order_view where customer_id = $_customerId order by id;');
            } else if (_purchaseId.isNotEmpty) {
              return Sql(sql: 'select * from customer_order_view where purchase_id = $_purchaseId order by id;');
            }
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
          const Field(flex: 03, hidden: false, editable: false, key: 'id'),
                Field(flex: 10, hidden: false, editable: false, title: 'Customer'.inRu, key: 'customer_id', relation: Relation(id: 'customer_id', field: 'name')),
          // const Field(hidden: false, editable: false, key: 'customer'),
                Field(hidden: true, editable: true, title: 'Purchase'.inRu, key: 'purchase_id', relation: Relation(id: 'purchase_id', field: 'name')),
                Field(flex: 10, hidden: false, editable: false, title: 'Purchase'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'purchase')),
                Field(flex: 03, hidden: false, editable: false, title: 'Purchase Item'.inRu, key: 'purchase_item_id'),
                Field(flex: 15, hidden: false, editable: false, title: 'Product'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'product')),
          // const Field(hidden: false, editable: true, key: 'purchase'),
          // const Field(hidden: false, editable: true, key: 'product'),
                Field(flex: 05, hidden: false, editable: true, title: 'Count'.inRu, key: 'count', hint: 'Количество единиц товара по позиции'.inRu),
                Field(flex: 05, hidden: false, editable: false, title: 'Cost'.inRu, key: 'cost', hint: 'Цена заказа с учетом количества единиц товара и стоимости доставки'.inRu),
                Field(flex: 05, hidden: false, editable: false, title: 'Paid'.inRu, key: 'paid', hint: 'Сумма уже оплаченная клиентом по позиции'.inRu),
                Field(flex: 05, hidden: false, editable: true, title: 'Distributed'.inRu, key: 'distributed', hint: 'Количество единиц товара, выданных клиенту'.inRu),
                Field(flex: 05, hidden: false, editable: true, title: 'To refound'.inRu, key: 'to_refound', hint: 'Сумма подлежащщая к возврату по позиции'.inRu),
                Field(flex: 05, hidden: false, editable: true, title: 'Refounded'.inRu, key: 'refounded', hint: 'Сумма которую клиенту вернули по позиции'.inRu),
                Field(flex: 15, hidden: false, editable: true, title: 'Description'.inRu, key: 'description'),
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
                Field(key: 'purchase_id'),
          const Field(key: 'purchase'),
          const Field(key: 'product_id'),
          const Field(key: 'product'),
        ],
      ),
      'purchase_id': TableSchema<EntryPurchase, void>(
        read: SqlRead<EntryPurchase, void>(
          address: _apiAddress,
          authToken: widget.authToken,
          database: _database,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select id, name, status from purchase order by id;');
          },
          entryBuilder: (row) => EntryPurchase.from(row),
          debug: true,
        ),
        fields: [
          const Field(key: 'id'),
          const Field(key: 'name'),
          const Field(key: 'status'),
        ],
      ),

    };
  }
  ///
  /// Returns [Field] by it's key
  Field _field(List<Field> fields, String key) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryCustomerOrder>(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    final customerField = _field(_schema.fields, 'customer_id');
    final purchaseField = _field(_schema.fields, 'purchase_id');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder(
          stream: _schema.stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            switch (snapshot.data) {
              case Ok(value: _):
                return EditListWidget(
                  id: _customerId,
                  relation: EditListEntry(
                    entries: _schema.relations[customerField.relation.id] ?? [],
                    field: customerField.relation.field,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  labelText: customerField.title.inRu,
                  onComplete: (customerId) {
                    if (customerId != _customerId) {
                      setState(() {
                        _customerId = customerId;
                        _log.debug('.build.onComplete | _customerId: $_customerId');
                      });
                    }
                  },
                );
              case Err(error: _):                
                return CircularProgressIndicator();
              case null:                
                return CircularProgressIndicator();
            }
            return CircularProgressIndicator.adaptive();
          }
        ),
        StreamBuilder(
          stream: _schema.stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            switch (snapshot.data) {
              case Ok(value: _):
                return EditListWidget(
                  id: _purchaseId,
                  relation: EditListEntry(
                    entries: _schema.relations[purchaseField.relation.id] ?? [],
                    field: purchaseField.relation.field,
                  ),
                  editable: [AppUserRole.admin, AppUserRole.operator].contains(widget.user.role),
                  style: Theme.of(context).textTheme.bodyLarge,
                  labelText: purchaseField.title.inRu,
                  onComplete: (purchaseId) {
                    if (purchaseId != _purchaseId) {
                      setState(() {
                        _purchaseId = purchaseId;
                        _log.debug('.build.onComplete | _purchaseId: $_purchaseId');
                      });
                    }
                  },
                );
              case Err(error: _):                
                return CircularProgressIndicator();
              case null:                
                return CircularProgressIndicator();
            }
            return CircularProgressIndicator.adaptive();
          }
        ),
        Expanded(
          child: TableWidget<EntryCustomerOrder, void>(
            schema: _schema,
            showDeleted: [AppUserRole.admin].contains(widget.user.role) ? false : null,
            fetchAction: TableWidgetAction(
              onPressed: (schema) {
                return Future.value(Ok(EntryCustomerOrder.empty()));
              }, 
              icon: const Icon(Icons.add),
            ),
            editAction: TableWidgetAction(
              onPressed: (schema) {
                final toBeUpdated = schema.entries.values.where((e) => e.isSelected).toList();
                if (toBeUpdated.isNotEmpty) {
                  return showDialog<Result<EntryCustomerOrder, void>?>(
                    context: context, 
                    builder: (_) => EditCustomerOrderForm(fields: schema.fields, entry: toBeUpdated.lastOrNull, relations: schema.relations),
                  ).then((result) {
                    _log.debug('.build | edited entry: $result');
                    return switch (result) {
                      Ok(:final value) => Ok(value),
                      Err(:final error) => Err(error),
                      _ => const Err(null),
                    };
                  });
                }
                return Future.value(Err(null));
              }, 
              icon: const Icon(Icons.add),
            ),      
          ),
        ),
      ],
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
