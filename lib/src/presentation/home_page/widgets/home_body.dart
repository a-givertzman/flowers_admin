import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_product_category.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_purchase_content.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/customer_page/customer_page.dart';
import 'package:flowers_admin/src/presentation/product_page/product_page.dart';
import 'package:flowers_admin/src/presentation/transaction_page/transaction_page.dart';
import 'package:flutter/material.dart';
///
///
class HomeBody extends StatefulWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const HomeBody({
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
  State<HomeBody> createState() => _HomeBodyState(
    authToken: _authToken,
    user: _user,
  );
}
///
///
class _HomeBodyState extends State<HomeBody> {
  // final _log = Log("$_HomeBodyState._");
  final String _authToken;
  final AppUser _user;
  final _database = 'flowers_app_server';
  final _apiAddress = const ApiAddress(host: '127.0.0.1', port: 8080);
  final _paddingH = 8.0;
  final _paddingV = 8.0;
  ///
  ///
  _HomeBodyState({
    required String authToken,
    required AppUser user,
  }):
    _authToken = authToken,
    _user = user;
  ///
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
            //
            // Customer Page
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: CustomerPage(
                authToken: _authToken,
                user: _user,
              ),
            ),
            //
            // Transaction Page
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TransactionPage(
                authToken: _authToken,
                user: _user,
              ),
            ),
            //
            // Product category Page
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                schema: RelationSchema<EntryProductCategory, void>(
                  schema: TableSchema<EntryProductCategory, void>(
                    read: SqlRead<EntryProductCategory, void>(
                      address: _apiAddress, 
                      authToken: _authToken, 
                      database: _database, 
                      sqlBuilder: (sql, params) {
                        return Sql(sql: 'select * from product_category order by id;');
                      },
                      entryBuilder: (row) => EntryProductCategory.from(row.cast()),
                      debug: true,
                    ),
                    write: SqlWrite<EntryProductCategory>(
                      address: _apiAddress, 
                      authToken: _authToken, 
                      database: _database, 
                      updateSqlBuilder: updateSqlBuilderProductCategory,
                      // insertSqlBuilder: insertSqlBuilderProductCategory,
                      emptyEntryBuilder: EntryProductCategory.empty, 
                      debug: true,
                    ),
                    fields: [
                      const Field(hidden: false, editable: false, key: 'id'),
                      const Field(hidden: false, editable: true, key: 'category_id', relation: Relation(id: 'category_id', field: 'name')),
                      const Field(hidden: false, editable: true, key: 'name'),
                      const Field(hidden: false, editable: true, key: 'details'),
                      const Field(hidden: false, editable: true, key: 'description'),
                      const Field(hidden: false, editable: true, key: 'picture'),
                      const Field(hidden: true, editable: true, key: 'created'),
                      const Field(hidden: true, editable: true, key: 'updated'),
                      const Field(hidden: true, editable: true, key: 'deleted'),
                    ],
                  ),
                  relations: {
                    'category_id': TableSchema<EntryProductCategory, void>(
                      read: SqlRead<EntryProductCategory, void>(
                        address: _apiAddress, 
                        authToken: _authToken, 
                        database: _database, 
                        sqlBuilder: (sql, params) {
                          return Sql(sql: 'select id, name from product_category order by id;');
                        },
                        entryBuilder: (row) => EntryProductCategory.from(row),
                        debug: true,
                      ),
                      fields: [
                        const Field(key: 'id'),
                        const Field(key: 'name'),
                      ],
                    ),
                  },                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: ProductPage(
                authToken: _authToken,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                schema: TableSchema<EntryPurchase, void>(
                  read: SqlRead<EntryPurchase, void>(
                    address: _apiAddress, 
                    authToken: _authToken, 
                    database: _database, 
                    sqlBuilder: (sql, params) {
                      return Sql(sql: 'select * from purchase order by id;');
                    },
                    entryBuilder: (row) => EntryPurchase.from(row),
                    debug: true,
                  ),
                  write: SqlWrite<EntryPurchase>(
                    address: _apiAddress, 
                    authToken: _authToken, 
                    database: _database, 
                    updateSqlBuilder: updateSqlBuilderPurchase,
                    // insertSqlBuilder: insertSqlBuilderPurchase,
                    emptyEntryBuilder: EntryPurchase.empty, 
                    debug: true,
                  ),                  
                  fields: [
                  const Field(hidden: false, editable: false, key: 'id'),
                  const Field(hidden: false, editable: true, key: 'name'),
                  const Field(hidden: false, editable: true, key: 'details'),
                  const Field(hidden: false, editable: true, key: 'status'),
                  const Field(hidden: false, editable: true, key: 'date_of_start'),
                  const Field(hidden: false, editable: true, key: 'date_of_end'),
                  const Field(hidden: false, editable: true, key: 'description'),
                  const Field(hidden: false, editable: true, key: 'picture'),
                  const Field(hidden: true, editable: true, key: 'created'),
                  const Field(hidden: true, editable: true, key: 'updated'),
                  const Field(hidden: true, editable: true, key: 'deleted'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                schema: RelationSchema<EntryPurchaseContent, void>(
                  schema: TableSchema<EntryPurchaseContent, void>(
                    read: SqlRead<EntryPurchaseContent, void>(
                      address: _apiAddress, 
                      authToken: _authToken, 
                      database: _database, 
                      sqlBuilder: (sql, params) {
                        return Sql(sql: 'select * from purchase_content order by id;');
                      },
                      entryBuilder: (row) => EntryPurchaseContent.from(row),
                      debug: true,
                    ),
                    write: SqlWrite<EntryPurchaseContent>(
                      address: _apiAddress, 
                      authToken: _authToken, 
                      database: _database, 
                      updateSqlBuilder: updateSqlBuilderPurchaseContent,
                      // insertSqlBuilder: insertSqlBuilderPurchaseContent,
                      emptyEntryBuilder: EntryPurchaseContent.empty,
                      debug: true,
                    ),                  
                    fields: [
                      const Field(hidden: false, editable: false, key: 'id'),
                      const Field(hidden: false, editable: true, key: 'purchase_id', relation: Relation(id: 'purchase_id', field: 'name')),
                      const Field(hidden: false, editable: true, key: 'product_id', relation: Relation(id: 'product_id', field: 'name')),
                      const Field(hidden: false, editable: true, key: 'sale_price'),
                      const Field(hidden: false, editable: true, key: 'sale_currency'),
                      const Field(hidden: false, editable: true, key: 'shipping'),
                      const Field(hidden: false, editable: true, key: 'amount'),
                      const Field(hidden: false, editable: true, key: 'name'),
                      const Field(hidden: false, editable: true, key: 'details'),
                      const Field(hidden: false, editable: true, key: 'description'),
                      const Field(hidden: false, editable: true, key: 'picture'),
                      const Field(hidden: true, editable: true, key: 'created'),
                      const Field(hidden: true, editable: true, key: 'updated'),
                      const Field(hidden: true, editable: true, key: 'deleted'),
                    ],
                  ),
                  relations: {
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
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _paddingV, horizontal: _paddingH),
              child: TableWidget(
                schema: RelationSchema<EntryCustomerOrder, void>(
                  schema: TableSchema<EntryCustomerOrder, void>(
                    read: SqlRead<EntryCustomerOrder, void>(
                      address: _apiAddress, 
                      authToken: _authToken, 
                      database: _database, 
                      sqlBuilder: (sql, params) {
                        return Sql(sql: 'select * from customer_order order by id;');
                      },
                      entryBuilder: (row) => EntryCustomerOrder.from(row),
                      debug: true,
                    ),
                    write: SqlWrite<EntryCustomerOrder>(
                      address: _apiAddress, 
                      authToken: _authToken, 
                      database: _database, 
                      updateSqlBuilder: updateSqlBuilderCustomerOrder,
                      // insertSqlBuilder: insertSqlBuilderCustomerOrder,
                      emptyEntryBuilder: EntryCustomerOrder.empty,
                      debug: true,
                    ),                  
                    fields: [
                      const Field(hidden: false, editable: false, key: 'id'),
                      const Field(hidden: false, editable: false, key: 'customer_id', relation: Relation(id: 'customer_id', field: 'name')),
                      // const Field(hidden: false, editable: false, key: 'customer'),
                      const Field(hidden: false, editable: true, key: 'purchase_content_id'),
                      const Field(hidden: false, editable: true, title: 'Purchase id', key: 'purchase_content_id', relation: Relation(id: 'purchase_content_id', field: 'purchase')),
                      const Field(hidden: false, editable: true, title: 'Product id', key: 'purchase_content_id', relation: Relation(id: 'purchase_content_id', field: 'product')),
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
                    'purchase_content_id': TableSchema<EntryPurchaseContent, void>(
                      read: SqlRead<EntryPurchaseContent, void>(
                        address: _apiAddress, 
                        authToken: _authToken, 
                        database: _database, 
                        sqlBuilder: (sql, params) {
                          return Sql(sql: 'select id, purchase_id, purchase, product_id, product from purchase_content_view order by id;');
                        },
                        entryBuilder: (row) => EntryPurchaseContent.from(row),
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
Sql updateSqlBuilderProductCategory(Sql sql, EntryProductCategory entry) {
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
Sql updateSqlBuilderPurchase(Sql sql, EntryPurchase entry) {
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
Sql updateSqlBuilderPurchaseContent(Sql sql, EntryPurchaseContent entry) {
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
Sql updateSqlBuilderCustomerOrder(Sql sql, EntryCustomerOrder entry) {
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
Sql updateSqlBuilder(Sql sql, SchemaEntry entry) {
  return Sql(sql: """UPDATE _____ SET (
  ) = (
    '${entry.value('')}'
  )
  WHERE id = ${entry.value('id')};
""");
}
