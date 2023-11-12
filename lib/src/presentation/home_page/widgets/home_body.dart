import 'package:dart_api_client/dart_api_client.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_product_category.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_purchase_content.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_transaction.dart';
import 'package:flowers_admin/src/infrostructure/schames/field.dart';
import 'package:flowers_admin/src/infrostructure/schames/scheme.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/schames/scheme_entry.dart';
import 'package:flowers_admin/src/infrostructure/schames/sql.dart';
import 'package:flowers_admin/src/presentation/home_page/widgets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final _log = Log("$_HomeBodyState._");
  final _paddingH = 8.0;
  final _paddingV = 8.0;
  ///
  @override
  Widget build(BuildContext context) {
    final tabHeadesStyle = Theme.of(context).textTheme.headlineSmall;
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.amber,
          indicatorSize: TabBarIndicatorSize.tab, 
          isScrollable: true,
          // indicator: BoxDecoration(
          //   color: Theme.of(context).cardColor,
          // ),
          tabs: [
            Tab(child: Text("customer", style: tabHeadesStyle)),
            Tab(child: Text("transaction", style: tabHeadesStyle)),
            Tab(child: Text("product_category", style: tabHeadesStyle)),
            Tab(child: Text("product", style: tabHeadesStyle)),
            Tab(child: Text("purchase", style: tabHeadesStyle)),
            Tab(child: Text("purchase_content", style: tabHeadesStyle)),
            Tab(child: Text("order", style: tabHeadesStyle)),
          ],
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                scheme: Scheme<EntryCustomer>(
                  address: const ApiAddress(host: '127.0.0.1', port: 8080),
                  authToken: 'some auth token', 
                  database: 'flowers_app_server', 
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
                    const Field(hidden: false, edit: true, key: 'created'),
                    const Field(hidden: false, edit: true, key: 'updated'),
                    const Field(hidden: false, edit: true, key: 'deleted'),
                  ],
                  fetchSqlBuilder: (values) {
                    return Sql(sql: 'select * from customer order by id;');
                  },
                  updateSqlBuilder: updateSqlBuilder_Customer,
                  debug: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                scheme: Scheme<EntryTransaction>(
                  address: const ApiAddress(host: '127.0.0.1', port: 8080),
                  authToken: 'some auth token', 
                  database: 'flowers_app_server', 
                  fields: [
                    const Field(hidden: false, edit: false, key: 'id'),
                    const Field(hidden: false, edit: true, key: 'timestamp'),
                    const Field(hidden: false, edit: true, key: 'account_owner'),
                    const Field(hidden: false, edit: true, key: 'value'),
                    const Field(hidden: false, edit: true, key: 'description'),
                    const Field(hidden: false, edit: true, key: 'order_id'),
                    const Field(hidden: false, edit: true, key: 'customer_id'),
                    const Field(hidden: false, edit: true, key: 'customer_account'),
                    const Field(hidden: false, edit: true, key: 'created'),
                    const Field(hidden: false, edit: true, key: 'updated'),
                    const Field(hidden: false, edit: true, key: 'deleted'),
                  ],
                  fetchSqlBuilder: (values) {
                    return Sql(sql: 'select * from transaction order by id;');
                  },
                  updateSqlBuilder: updateSqlBuilder_Transaction,
                  debug: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                scheme: Scheme<EntryProductCategory>(
                  address: const ApiAddress(host: '127.0.0.1', port: 8080),
                  authToken: 'some auth token', 
                  database: 'flowers_app_server', 
                  fields: [
                    const Field(hidden: false, edit: false, key: 'id'),
                    const Field(hidden: false, edit: true, key: 'category_id'),
                    const Field(hidden: false, edit: true, key: 'name'),
                    const Field(hidden: false, edit: true, key: 'details'),
                    const Field(hidden: false, edit: true, key: 'description'),
                    const Field(hidden: false, edit: true, key: 'picture'),
                    const Field(hidden: false, edit: true, key: 'created'),
                    const Field(hidden: false, edit: true, key: 'updated'),
                    const Field(hidden: false, edit: true, key: 'deleted'),
                  ],
                  fetchSqlBuilder: (values) {
                    return Sql(sql: 'select * from product_category order by id;');
                  },
                  updateSqlBuilder: updateSqlBuilder_ProductCategory,
                  debug: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                scheme: Scheme<EntryProduct>(
                  address: const ApiAddress(host: '127.0.0.1', port: 8080),
                  authToken: 'some auth token', 
                  database: 'flowers_app_server', 
                  fields: [
                    const Field(hidden: false, edit: false, key: 'id'),
                    const Field(hidden: false, edit: true, key: 'product_category_id'),
                    const Field(hidden: false, edit: true, key: 'category'),
                    const Field(hidden: false, edit: true, key: 'name'),
                    const Field(hidden: false, edit: true, key: 'details'),
                    const Field(hidden: false, edit: true, key: 'primary_price'),
                    const Field(hidden: false, edit: true, key: 'primary_currency'),
                    const Field(hidden: false, edit: true, key: 'primary_order_quantity'),
                    const Field(hidden: false, edit: true, key: 'order_quantity'),
                    const Field(hidden: false, edit: true, key: 'description'),
                    const Field(hidden: false, edit: true, key: 'picture'),
                    const Field(hidden: false, edit: true, key: 'created'),
                    const Field(hidden: false, edit: true, key: 'updated'),
                    const Field(hidden: false, edit: true, key: 'deleted'),
                  ],
                  fetchSqlBuilder: (values) {
                    return Sql(sql: 'select * from product_view order by id;');
                  },
                  updateSqlBuilder: updateSqlBuilder_Product,
                  debug: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                scheme: Scheme<EntryPurchase>(
                  address: const ApiAddress(host: '127.0.0.1', port: 8080),
                  authToken: 'some auth token', 
                  database: 'flowers_app_server', 
                  fields: [
                  const Field(hidden: false, edit: false, key: 'id'),
                  const Field(hidden: false, edit: true, key: 'name'),
                  const Field(hidden: false, edit: true, key: 'details'),
                  const Field(hidden: false, edit: true, key: 'status'),
                  const Field(hidden: false, edit: true, key: 'date_of_start'),
                  const Field(hidden: false, edit: true, key: 'date_of_end'),
                  const Field(hidden: false, edit: true, key: 'description'),
                  const Field(hidden: false, edit: true, key: 'picture'),
                  const Field(hidden: false, edit: true, key: 'created'),
                  const Field(hidden: false, edit: true, key: 'updated'),
                  const Field(hidden: false, edit: true, key: 'deleted'),
                  ],
                  fetchSqlBuilder: (values) {
                    return Sql(sql: 'select * from purchase order by id;');
                  },
                  updateSqlBuilder: updateSqlBuilder_Purchase,
                  debug: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                scheme: Scheme<EntryPurchaseContent>(
                  address: const ApiAddress(host: '127.0.0.1', port: 8080),
                  authToken: 'some auth token', 
                  database: 'flowers_app_server', 
                  fields: [
                    const Field(hidden: false, edit: false, key: 'id'),
                    const Field(hidden: false, edit: true, key: 'purchase_id'),
                    const Field(hidden: false, edit: true, key: 'purchase'),
                    const Field(hidden: false, edit: true, key: 'product_id'),
                    const Field(hidden: false, edit: true, key: 'product'),
                    const Field(hidden: false, edit: true, key: 'sale_price'),
                    const Field(hidden: false, edit: true, key: 'sale_currency'),
                    const Field(hidden: false, edit: true, key: 'shipping'),
                    const Field(hidden: false, edit: true, key: 'amount'),
                    const Field(hidden: false, edit: true, key: 'name'),
                    const Field(hidden: false, edit: true, key: 'details'),
                    const Field(hidden: false, edit: true, key: 'description'),
                    const Field(hidden: false, edit: true, key: 'picture'),
                    const Field(hidden: false, edit: true, key: 'created'),
                    const Field(hidden: false, edit: true, key: 'updated'),
                    const Field(hidden: false, edit: true, key: 'deleted'),
                  ],
                  fetchSqlBuilder: (values) {
                    return Sql(sql: 'select * from purchase_content_view order by id;');
                  },
                  updateSqlBuilder: updateSqlBuilder_PurchaseContent,
                  debug: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                scheme: Scheme<EntryCustomerOrder>(
                  address: const ApiAddress(host: '127.0.0.1', port: 8080),
                  authToken: 'some auth token', 
                  database: 'flowers_app_server', 
                  fields: [
                    const Field(hidden: false, edit: false, key: 'id'),
                    const Field(hidden: false, edit: true, key: 'customer_id'),
                    const Field(hidden: false, edit: true, key: 'customer'),
                    const Field(hidden: false, edit: true, key: 'purchase_content_id'),
                    const Field(hidden: false, edit: true, key: 'purchase'),
                    const Field(hidden: false, edit: true, key: 'product'),
                    const Field(hidden: false, edit: true, key: 'count'),
                    const Field(hidden: false, edit: true, key: 'paid'),
                    const Field(hidden: false, edit: true, key: 'distributed'),
                    const Field(hidden: false, edit: true, key: 'to_refound'),
                    const Field(hidden: false, edit: true, key: 'refounded'),
                    const Field(hidden: false, edit: true, key: 'description'),
                    const Field(hidden: true, edit: true, key: 'created'),
                    const Field(hidden: true, edit: true, key: 'updated'),
                    const Field(hidden: true, edit: true, key: 'deleted'),
                  ],
                  fetchSqlBuilder: (values) {
                    return Sql(sql: 'select * from customer_order_view order by id;');
                  },
                  updateSqlBuilder: updateSqlBuilder_CustomerOrder,
                  debug: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
///
///
Sql updateSqlBuilder_Customer(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE customer SET (
    id,
    role,
    email,
    phone,
    name,
    location,
    login,
    pass,
    account,
    last_act,
    blocked,
    created,
    updated,
    deleted
  ) = (
    ${entry.value('id').str},
    ${entry.value('role').str},
    ${entry.value('email').str},
    ${entry.value('phone').str},
    ${entry.value('name').str},
    ${entry.value('location').str},
    ${entry.value('login').str},
    ${entry.value('pass').str},
    ${entry.value('account').str},
    ${entry.value('last_act').str},
    ${entry.value('blocked').str},
    ${entry.value('created').str},
    ${entry.value('updated').str},
    ${entry.value('deleted').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql updateSqlBuilder_Transaction(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE transaction SET (
    id,
    timestamp,
    account_owner,
    value,
    description,
    order_id,
    customer_id,
    customer_account,
    created,
    updated,
    deleted
  ) = (
    ${entry.value('id').str},
    ${entry.value('timestamp').str},
    ${entry.value('account_owner').str},
    ${entry.value('value').str},
    ${entry.value('description').str},
    ${entry.value('order_id').str},
    ${entry.value('customer_id').str},
    ${entry.value('customer_account').str},
    ${entry.value('created').str},
    ${entry.value('updated').str},
    ${entry.value('deleted').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql updateSqlBuilder_ProductCategory(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE product_category SET (
    id,
    category_id,
    name,
    details,
    description,
    picture,
    created,
    updated,
    deleted
  ) = (
    ${entry.value('id').str},
    ${entry.value('category_id').str},
    ${entry.value('name').str},
    ${entry.value('details').str},
    ${entry.value('description').str},
    ${entry.value('picture').str},
    ${entry.value('created').str},
    ${entry.value('updated').str},
    ${entry.value('deleted').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql updateSqlBuilder_Product(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE product SET (
    id,
    product_category_id,
    name,
    details,
    primary_price,
    primary_currency,
    primary_order_quantity,
    order_quantity,
    description,
    picture,
    created,
    updated,
    deleted
  ) = (
    ${entry.value('id').str},
    ${entry.value('product_category_id').str},
    ${entry.value('name').str},
    ${entry.value('details').str},
    ${entry.value('primary_price').str},
    ${entry.value('primary_currency').str},
    ${entry.value('primary_order_quantity').str},
    ${entry.value('order_quantity').str},
    ${entry.value('description').str},
    ${entry.value('picture').str},
    ${entry.value('created').str},
    ${entry.value('updated').str},
    ${entry.value('deleted').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql updateSqlBuilder_Purchase(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE purchase SET (
    id,
    name,
    details,
    status,
    date_of_start,
    date_of_end,
    description,
    picture,
    created,
    updated,
    deleted
  ) = (
    ${entry.value('id').str},
    ${entry.value('name').str},
    ${entry.value('details').str},
    ${entry.value('status').str},
    ${entry.value('date_of_start').str},
    ${entry.value('date_of_end').str},
    ${entry.value('description').str},
    ${entry.value('picture').str},
    ${entry.value('created').str},
    ${entry.value('updated').str},
    ${entry.value('deleted').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql updateSqlBuilder_PurchaseContent(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE purchase_content SET (
    id,
    purchase_id,
    product_id,
    sale_price,
    sale_currency,
    shipping,
    amount,
    name,
    details,
    description,
    picture,
    created,
    updated,
    deleted
  ) = (
    ${entry.value('id').str},
    ${entry.value('purchase_id').str},
    ${entry.value('product_id').str},
    ${entry.value('sale_price').str},
    ${entry.value('sale_currency').str},
    ${entry.value('shipping').str},
    ${entry.value('amount').str},
    ${entry.value('name').str},
    ${entry.value('details').str},
    ${entry.value('description').str},
    ${entry.value('picture').str},
    ${entry.value('created').str},
    ${entry.value('updated').str},
    ${entry.value('deleted').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql updateSqlBuilder_CustomerOrder(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE customer_order SET (
    id,
    customer_id,
    purchase_content_id,
    count,
    paid,
    distributed,
    to_refound,
    refounded,
    description
  ) = (
    ${entry.value('id').str},
    ${entry.value('customer_id').str},
    ${entry.value('purchase_content_id').str},
    ${entry.value('count').str},
    ${entry.value('paid').str},
    ${entry.value('distributed').str},
    ${entry.value('to_refound').str},
    ${entry.value('refounded').str},
    ${entry.value('description').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql updateSqlBuilder(Sql sql, SchemeEntry entry) {
  return Sql(sql: """UPDATE _____ SET (
  ) = (
    '${entry.value('')}'
  )
  WHERE id = ${entry.value('id')};
""");
}
