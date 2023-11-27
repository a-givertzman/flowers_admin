import 'package:flowers_admin/src/infrostructure/schamas/schema_entry.dart';
import 'package:flowers_admin/src/infrostructure/schamas/sql.dart';

///
///
Sql updateSqlBuilderTransaction(Sql sql, SchemaEntry entry) {
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
Sql insertSqlBuilderTransaction(Sql sql, SchemaEntry entry) {
  return Sql(sql: """insert into transaction (
    timestamp,
    account_owner,
    value,
    description,
    order_id,
    customer_id,
    customer_account
  ) values (
    ${entry.value('timestamp').str},
    ${entry.value('account_owner').str},
    ${entry.value('value').str},
    ${entry.value('description').str},
    ${entry.value('order_id').str},
    ${entry.value('customer_id').str},
    ${entry.value('customer_account').str}
  );
""");
}
