import 'dart:async';

import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_pay_customer.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_pay_purchase.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_payment.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/presentation/payment_page/widgets/check_box_field.dart';
import 'package:flowers_admin/src/presentation/payment_page/widgets/check_list_widget.dart';
import 'package:flowers_admin/src/presentation/payment_page/widgets/overlay_progress_indicator.dart';
import 'package:flowers_admin/src/presentation/payment_page/widgets/pay_list_widget.dart';
import 'package:flowers_admin/src/presentation/payment_page/widgets/table_schema_ready.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:resizable_widget/resizable_widget.dart';
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
  late final TableSchemaAbstract<EntryPayment, void> _schema;
  final StreamController<int> _schemaStream = StreamController();
  final Map<int, EntryPayCustomer> _customers = {};
  final StreamController<int> _customersStream = StreamController();
  final Map<int, EntryPayPurchase> _purchases = {};
  final StreamController<int> _purchasesStream = StreamController();
  bool _isLoading = false;
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
    _fetch();
  }
  ///
  ///
  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
    });
    await _schema
      .fetch(null)
      .whenComplete(() async {
        setState(() {
          _isLoading = false;
        });
        _schemaStream.add(0);
      });
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
    if (_areAllCustomers() && _areAllPurchases()) {
      // _log.trace('._filter | All checked');
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
  TableSchemaAbstract<EntryPayment, void> _buildSchema() {
    final editableAuthor = [AppUserRole.admin].contains(_user.role);
    final editableValue = [AppUserRole.admin].contains(_user.role);
    final editableDetails = [AppUserRole.admin].contains(_user.role);
    return TableSchemaReady(
      onReady: (result) {
        switch (result) {
          case Ok<Map<String, EntryPayment>, Failure>(value: final entries):
            _log.trace('.build | TableSchemaReady: _schema.entries: ${_schema.entries.length}');
            _log.trace('.build | TableSchemaReady: entries: ${entries.length}');
            _customers.clear();
            _schema.relations['customer_id']?.forEach((item) {
              _customers[item.value('id').value] = EntryPayCustomer.from({
                'pay': true,
                'id': item.value('id').value,
                'name': item.value('name').value,
              });
            });
            _customersStream.add(0);
            _purchases.clear();
            _schema.relations['purchase_item_id']?.forEach((item) {
              _purchases[item.value('id').value] = EntryPayPurchase.from({
                'pay': true,
                'id': item.value('purchase_id').value,
                'name': item.value('purchase').value,
              });
            });
            _purchasesStream.add(0);
            _log.trace('.build | Customer`s (${_customers.length}): ${_customers.map((id, c) => MapEntry(id, c.value('name').value))}');
            _log.trace('.build | Purchase`s (${_purchases.length}): ${_purchases.map((id, c) => MapEntry(id, c.value('name').value))}');
          case Err<Map<String, EntryPayment>, Failure>(: final error):
            _log.trace('.build | TableSchemaReady: $error');
        }
      },
      schema: RelationSchema<EntryPayment, void>(
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
              Field(hidden: false, key: 'pay', builder: (context, entry) => CheckBoxField(entry: entry, onChanged: (p0) => setState(() {return;}))),
              const Field(hidden: false, key: 'id'),
              Field(hidden: false, title: 'Customer'.inRu, key: 'customer_id', relation: Relation(id: 'customer_id', field: 'name')),
              // const Field(hidden: false, key: 'customer'),
              // const Field(hidden: false, key: 'purchase_item_id'),
              // Field(hidden: false, key: 'purchase_id', relation: Relation(id: 'purchase_id', field: 'name')),
              Field(hidden: false, title: 'Purchase'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'purchase')),
              Field(hidden: false, title: 'Product'.inRu, key: 'purchase_item_id', relation: Relation(id: 'purchase_item_id', field: 'product')),
              // const Field(hidden: false, key: 'purchase'),
              // const Field(hidden: false, key: 'product'),
              Field(hidden: false, title: 'Count'.inRu, key: 'count'),
              Field(hidden: false, title: 'Cost'.inRu, key: 'cost'),
              Field(hidden: false, title: 'Paid'.inRu, key: 'paid'),
              Field(hidden: false, title: 'Distributed'.inRu, key: 'distributed'),
              Field(hidden: false, title: 'to_refound'.inRu, key: 'to_refound'),
              Field(hidden: false, title: 'refounded'.inRu, key: 'refounded'),
              const Field(hidden: false, key: 'description'),
              const Field(hidden: true, key: 'created'),
              const Field(hidden: true, key: 'updated'),
              const Field(hidden: true, key: 'deleted'),
            ],
          ), 
        ),
        relations: {
          ..._buildCustomerRelation(),
          ..._buildPurchaseItemRelation(),
        },
      ),
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
            entryBuilder: (row) => EntryCustomer.from(row.cast()),
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
  ///
  /// Performs a `Payment` request
  Future<void> _paymentRequest() {
    _log.debug('._paymentRequest | Payment started');
    // final description = 'Оплата позиций:\n \t${_schema.entries.values.map((item) => '${item.value('purchase').value} - ${item.value('product').value}' ).join(';\n\t')}';
    final customers = _areAllCustomers() ? 'array[]::int[]' : 'array[${_customers.values.where((item) => item.value('pay').value).map((c) => c.value('id').str).join(', ')}]';
    final purchaseItems = 'array[${_schema.entries.values.where((item) {
      _log.debug('._paymentRequest | purchaseItem: ${item.value('purchase').value} - ${item.value('product').value},  pay: ${item.value('pay').value}');
      return item.value('pay').value;
    }).map((item) => item.value('purchase_item_id').value).join(', ')}]';
    setState(() {
      _isLoading = true;
    });
    return ApiRequest(
      authToken: _authToken,
      address: _apiAddress,
      query: SqlQuery(
        database: _database,
        sql: '''
          select * from set_order_payment(
              ${_user.id},      -- author
              $customers,       -- array[]::int[],   -- customer's
              $purchaseItems,   -- array[]::int[],   -- purchase_item's
              '',	              -- description, empty is prefer, default will be generated automaticaly
              false		          -- allow_indebted
          );
        ''',
      ),
    )
      .fetch()
      .then(
        (result) async {
          _log.debug('.build.IconButton.onPressed.then | Payment result $result');
          switch (result) {
            case Ok<ApiReply, Failure>():
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return Text('Оплата завершена успешно');
                }
              );
            case Err<ApiReply, Failure>(: final error):
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return Text('Ошибка: \n\t$error');
                }
              );
          }
        },
        onError: (error) {
          _log.warning('.build.IconButton.onPressed.then | Payment error $error');
        },
      )
      .whenComplete(() async {
        await _fetch();
        setState(() {
          _isLoading = false;
        });
      });
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Tooltip(
                  message: 'Perform payments',
                  child: TextButton.icon(
                    onPressed: _paymentRequest,
                    label: Text('Payments'),
                    icon: Icon(Icons.payments),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ResizableWidget(
                isHorizontalSeparator: true,
                percentages: [0.40, 0.60],
                children: [
                  ResizableWidget(
                    isDisabledSmartHide: true,
                    percentages: [0.50, 0.50],
                    children: [
                      // Purchases
                      Card(
                        color: Colors.amber[50],
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text('${'Purchase'.inRu} (${_purchases.length})', style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Divider(),
                            Expanded(
                              child: StreamBuilder<int>(
                                stream: _purchasesStream.stream,
                                builder: (context, snapshot) {
                                  return CheckListWidget(
                                    items: _purchases,
                                    onChanged: (entries) {
                                      _purchases.updateAll((key, value) {
                                        return entries[key] as EntryPayPurchase;
                                      });
                                      _schemaStream.add(0);
                                    },
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Customers
                      Card(
                        color: Colors.blue[50],
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text('${'Customer'.inRu} (${_customers.length})', style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Divider(),
                            Expanded(
                              child: StreamBuilder<int>(
                                stream: _customersStream.stream,
                                builder: (context, snapshot) {
                                  return CheckListWidget(
                                    items: _customers,
                                    onChanged: (entries) {
                                      _customers.updateAll((key, value) {
                                        return entries[key] as EntryPayCustomer;
                                      });
                                      _log.trace('.build.onChanged | Customer`s (${_customers.length}): ${_customers.map((id, c) => MapEntry(id, c.value('name').value))}');
                                      _schemaStream.add(0);
                                    },
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Orders
                  Card(
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
                          child: StreamBuilder<int>(
                            stream: _schemaStream.stream,
                            builder: (context, snapshot) {
                              return PayListWidget<EntryPayment>(
                                header: _schema.fields,
                                items: _schema.entries,
                                onChanged: (entries) {
                                  
                                },
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_isLoading) OverlayProgressIndicator(),
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
          child: Text('Cancel'.inRu),
          onPressed:  () {
            Navigator.pop(context, const Err(null));
          },
        ),
        TextButton(
          child: Text('Yes'.inRu),
          onPressed:  () {
            Navigator.pop(context, const Ok(null));
          },
        ),
      ],              
    ),
  )
  .then((value) => value ?? const Err(null));
}
