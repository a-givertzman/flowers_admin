import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_pay_customer.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_pay_purchase.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_pay_purchase_item.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_payment.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
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
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<PaymentBody> createState() => _PaymentBodyState(
    authToken: _authToken,
    user: _user,
  );
}
//
//
class _PaymentBodyState extends State<PaymentBody> {
  late final Log _log;
  final String _authToken;
  final AppUser _user;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final RelationSchema<EntryPayment, void> _schema;
  final Map<int, EntryPayPurchase> _purchases = {};
  final Map<int, EntryPayPurchaseItem> _purchaseItems = {};
  final Map<int, EntryPayCustomer> _customers = {};
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
  //
  //
  @override
  void initState() {
    _schema = _buildSchema();
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () => setState(() {return;}));
  }
  ///
  /// Returns true if all customer's are checked
  bool _areAllCustomers() {
    return !_customers.entries.any((entry) => !entry.value.value('pay').value);
  }
  ///
  /// Returns true if all purchase's are checked
  bool _areAllPurchases() {
    return !_purchases.entries.any((entry) => !entry.value.value('pay').value);
  }
  ///
  ///
  bool _filter(EntryPayment entry) {
    // final customersAllChecked = !_customers.entries.any((entry) => !entry.value.value('pay').value);
    // final purchasesAllChecked = !_purchases.entries.any((entry) => !entry.value.value('pay').value);
    if (_areAllCustomers() && _areAllPurchases()) {
      _log.warning('._filter | All checked');
      return true;
    }
    final customerId = entry.value('customer_id').value;
    final purchaseId = entry.value('purchase_id').value;
    final customerIsChecked = _customers[customerId]?.value('pay').value ?? false;
    final purchaseIsChecked = _purchases[purchaseId]?.value('pay').value ?? false;
    _log.warning('._filter | customerId $customerId,  purchaseId $purchaseId,  checked: ${customerIsChecked && purchaseIsChecked}');
    return customerIsChecked && purchaseIsChecked;
  }
  ///
  /// Returns TableSchema
  RelationSchema<EntryPayment, void> _buildSchema() {
    final editableAuthor = [AppUserRole.admin].contains(_user.role);
    final editableValue = [AppUserRole.admin].contains(_user.role);
    final editableDetails = [AppUserRole.admin].contains(_user.role);
    return RelationSchema<EntryPayment, void>(
      schema: TableSchemaFiltered(
        filter: _filter,
        schema: TableSchema<EntryPayment, void>(
          read: SqlRead<EntryPayment, void>.keep(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database,
            sqlBuilder: (sql, params) {
              return Sql(sql: 'select * from customer_order_view order by id;');
            },
            entryBuilder: (row) {
              return EntryPayment.from({
                ...{'pay': true},
                ...row.cast(),
            });
            },
            debug: true,
          ),
          write: SqlWrite<EntryPayment>.keep(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database, 
            emptyEntryBuilder: EntryPayment.empty,
            debug: true,
          ),
          fields: [
            Field(hidden: false, editable: false, key: 'pay', builder: (context, entry) => CheckBoxField(entry: entry)),
            const Field(hidden: false, editable: false, key: 'id'),
            Field(hidden: false, editable: false, title: 'Customer'.inRu, key: 'customer_id', relation: Relation(id: 'customer_id', field: 'name')),
            // const Field(hidden: false, editable: false, key: 'customer'),
            // const Field(hidden: false, editable: true, key: 'purchase_item_id'),
            // Field(hidden: false, editable: true, key: 'purchase_id', relation: Relation(id: 'purchase_id', field: 'name')),
            Field(hidden: false, editable: true, title: 'Purchase'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'purchase')),
            Field(hidden: false, editable: true, title: 'Product'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'product')),
            // const Field(hidden: false, editable: true, key: 'purchase'),
            // const Field(hidden: false, editable: true, key: 'product'),
            Field(hidden: false, editable: true, title: 'Count'.inRu, key: 'count'),
            Field(hidden: false, editable: true, title: 'Paid'.inRu, key: 'paid'),
            Field(hidden: false, editable: true, title: 'Distributed'.inRu, key: 'distributed'),
            Field(hidden: false, editable: true, title: 'to_refound'.inRu, key: 'to_refound'),
            Field(hidden: false, editable: true, title: 'refounded'.inRu, key: 'refounded'),
            const Field(hidden: false, editable: true, key: 'description'),
            const Field(hidden: true, editable: true, key: 'created'),
            const Field(hidden: true, editable: true, key: 'updated'),
            const Field(hidden: true, editable: true, key: 'deleted'),
          ],
        ), 
      ),
      relations: {
        ..._buildCustomerRelation(),
        ..._buildPurchaseItemRelation(),
      },
    );
  }
  ///
  /// Returns Relations
  Map<String, TableSchema<SchemaEntryAbstract, void>> _buildCustomerRelation() {
    return {
        'customer_id': TableSchema<EntryCustomer, void>(
          read: SqlRead<EntryCustomer, void>.keep(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database, 
            sqlBuilder: (sql, params) {
              return Sql(sql: 'select id, name from customer order by id;');
            },
            entryBuilder: (row) {
              final payCustomer = EntryPayCustomer.from({
                ...{'pay': true},
                ...row,
            });
              _customers.putIfAbsent(payCustomer.value('id').value, () => payCustomer);
              return EntryCustomer.from(row.cast());
            },
            debug: true,
          ),
          fields: [const Field(key: 'id'), const Field(key: 'name')],
        ),
      };
  }
  ///
  /// Returns Relations
  Map<String, TableSchema<SchemaEntryAbstract, void>> _buildPurchaseItemRelation() {
    return {
        'purchase_item_id': TableSchema<EntryPurchaseItem, void>(
          read: SqlRead<EntryPurchaseItem, void>.keep(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database, 
            sqlBuilder: (sql, params) {
              return Sql(sql: 'select id, purchase_id, purchase, product_id, product from purchase_item_view order by id;');
            },
            entryBuilder: (row) {
              // _log.warning('._buildRelations | row $row');
              final payPurchase = EntryPayPurchase.from({
                'pay': true,
                'id': row['purchase_id'],
                'name': row['purchase'],
              });
              _purchases.putIfAbsent(payPurchase.value('id').value, () => payPurchase);
              return EntryPurchaseItem.from(row);
            },
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
    _log.warning('.build | Customers ${_customers.map((id, c) => MapEntry(id, c.value('name').value))}');
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  _log.debug('.build.IconButton.onPressed | Payment started');
                  final description = 'Payment description';
                  final customers = _areAllCustomers() ? 'array[]::int[]' : 'array[${_customers.values.map((c) => c.value('id').str)}]';
                  ApiRequest(
                    authToken: _authToken,
                    address: _apiAddress,
                    query: SqlQuery(
                      database: _database,
                      sql: '''
                        select * from set_order_payment(
                            ${_user.id},      -- author
                            $customers        -- array[]::int[],   -- customer's
                            array[]::int[],   -- purchase_item's
                            '$description',	  -- description
                            false		          -- allow_indebted
                        );
                      ''',
                    ),
                  ).fetch().then(
                    (result) {
                      _log.debug('.build.IconButton.onPressed.then | Payment result $result');
                      switch (result) {
                        case Ok<ApiReply, Failure>():
                          // TODO: Handle this case.
                        case Err<ApiReply, Failure>():
                          // TODO: Handle this case.
                      }
                    },
                    onError: (error) {
                      _log.warning('.build.IconButton.onPressed.then | Payment error $error');
                    },
                  );
                },
                child: Text('Pay'),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Purchases
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('Purchase'.inRu, style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Divider(),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: _purchases.length,
                          itemBuilder: (BuildContext context, int index) {
                            final id = _purchases.keys.elementAt(index);
                            final item = _purchases[id];
                            return Row(
                              children: [
                                Checkbox(
                                  value: item?.value('pay').value,
                                  onChanged: (value) {
                                    item?.update('pay', value);
                                    setState(() {return;});
                                  },
                                ),
                                Text('${item?.value('name').value}'),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Divider(indent: 8,),
              // Customers
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('Customer'.inRu, style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Divider(),
                      ListView.builder(
                            shrinkWrap: true,
                            itemCount: _customers.length,
                            itemBuilder: (BuildContext context, int index) {
                              final id = _customers.keys.elementAt(index);
                              final item = _customers[id];
                              return Row(
                                children: [
                                  Checkbox(
                                    value: item?.value('pay').value,
                                    onChanged: (value) {
                                      item?.update('pay', value);
                                      setState(() {return;});
                                    },
                                  ),
                                  Text('${item?.value('name').value}'),
                                ],
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Orders
          Expanded(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text('Заказы'.inRu, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Divider(),
                  Expanded(
                    child: TableWidget<EntryPayment, void>(
                      showDeleted: [AppUserRole.admin].contains(_user.role) ? false : null,
                      fetchAction: TableWidgetAction(
                        onPressed: (schema) {
                          return Future.value(Ok(EntryPayment.empty()));
                        }, 
                        icon: const Icon(Icons.add),
                      ),
                      schema: _schema,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
///
/// [TableWidget] CheckBox
class CheckBoxField extends StatefulWidget {
  final SchemaEntryAbstract _entry;
  ///
  /// [TableWidget] CheckBox
  const CheckBoxField({
    super.key,
    required SchemaEntryAbstract entry,
  }):
    _entry = entry;
  //
  //
  @override
  State<CheckBoxField> createState() => _CheckBoxFieldState();
}
//
//
class _CheckBoxFieldState extends State<CheckBoxField> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget._entry.value('pay').value,
      onChanged: (value) {
          widget._entry.update('pay', value);
          setState(() {return;});
      },
    );
  }
}