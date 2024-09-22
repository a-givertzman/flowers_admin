import 'package:ext_rw/ext_rw.dart';

///
///
Sql updateSqlBuilderTransaction(Sql sql, SchemaEntryAbstract entry) {
  return Sql(sql: """UPDATE transaction SET (
    id,
    author_id,
    value,
    details,
    order_id,
    customer_id,
    customer_account,
    description,
    updated,
    deleted
  ) = (
    ${entry.value('id').str},
    ${entry.value('author_id').str},
    ${entry.value('value').str},
    ${entry.value('details').str},
    ${entry.value('order_id').str},
    ${entry.value('customer_id').str},
    ${entry.value('customer_account').str},
    ${entry.value('description').str},
    ${entry.value('updated').str},
    ${entry.value('deleted').str}
  )
  WHERE id = ${entry.value('id').str};
""");
}
///
///
Sql insertSqlBuilderTransaction(Sql sql, SchemaEntryAbstract entry) {
  return Sql(sql: """insert into transaction (
    author_id,
    value,
    details,
    order_id,
    customer_id,
    description
  ) values (
    ${entry.value('author_id').str},
    ${entry.value('value').str},
    ${entry.value('details').str},
    ${entry.value('order_id').str},
    ${entry.value('customer_id').str},
    ${entry.value('description').str}
  );
""");
}
