import 'package:ext_rw/ext_rw.dart';
///
/// Returns SQL to insert/update the transaction
/// ```
/// select set_transaction(
/// 	author_id_ int8,
///   customer_id_ int8,
///   value_ numeric(20, 2),
///   details_ varchar(2048),
///   order_id_ int8,
///   description_ varchar(2048),
///   allow_indebted bool,
///   -- returns
///   out result_account numeric(20, 2),
///   out result_error text)
/// );
/// select set_transaction(15, 2, -33.33, 'Testing transaction - 33.33', null, 'Empty description', false);
/// select set_transaction(15, 2, 100.33, 'Testing transaction +100.33', null, 'Empty description', false);
/// select set_transaction(15, 2, 100.33, 'Testing transaction +100.33',    1, 'Empty description', false);
/// ```
///
/// Returns SQL to update the transaction
/// - [author_id]           - int8, Person who created the transaction
///	- [customer_id]         - int8, Cuctomer which account will be proccesed
///	- [value]               - numeric(20, 2), The amount to be transferred to/from Customers' account
///	- [details]             - varchar(2048), Transfer/Payment details
/// - [order_id]            - int8, If not NULL, trunsactions refers to the Customer's order
/// - [description]         - varchar(2048), Additional info about transfer
///	- [allow_indebted]      - bool, allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
///
Sql updateSqlBuilderTransaction(Sql sql, SchemaEntryAbstract entry) {
  return Sql(sql: """select
    edit_transaction(
      ${entry.value('author_id').str},
      ${entry.value('customer_id').str},
      ${entry.value('value').str},
      ${entry.value('details').str},
      ${entry.value('order_id').str},
      ${entry.value('description').str},
      false
    );
""");
//   return Sql(sql: """UPDATE transaction SET (
//     id,
//     author_id,
//     value,
//     details,
//     order_id,
//     customer_id,
//     customer_account,
//     description,
//     updated,
//     deleted
//   ) = (
//     ${entry.value('id').str},
//     ${entry.value('author_id').str},
//     ${entry.value('value').str},
//     ${entry.value('details').str},
//     ${entry.value('order_id').str},
//     ${entry.value('customer_id').str},
//     ${entry.value('customer_account').str},
//     ${entry.value('description').str},
//     ${entry.value('updated').str},
//     ${entry.value('deleted').str}
//   )
//   WHERE id = ${entry.value('id').str};
// """);
}
///
/// Returns SQL to insert the transaction
/// - [author_id]           - int8, Person who created the transaction
///	- [customer_id]         - int8, Cuctomer which account will be proccesed
///	- [value]               - numeric(20, 2), The amount to be transferred to/from Customers' account
///	- [details]             - varchar(2048), Transfer/Payment details
/// - [order_id]            - int8, If not NULL, trunsactions refers to the Customer's order
/// - [description]         - varchar(2048), Additional info about transfer
///	- [allow_indebted]      - bool, allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
///
Sql insertSqlBuilderTransaction(Sql sql, SchemaEntryAbstract entry) {
  return Sql(sql: """select
    add_transaction(
      ${entry.value('author_id').str},
      ${entry.value('customer_id').str},
      ${entry.value('value').str},
      ${entry.value('details').str},
      ${entry.value('order_id').str},
      ${entry.value('description').str},
      false
    );
""");
}
