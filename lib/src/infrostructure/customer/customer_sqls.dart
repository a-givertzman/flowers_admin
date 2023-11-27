
import 'package:dart_api_client/dart_api_client.dart';

///
/// CUSTOMER
Sql updateSqlBuilderCustomer(Sql sql, SchemaEntry entry) {
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
Sql insertSqlBuilderCustomer(Sql sql, SchemaEntry entry) {
  return Sql(sql: """insert into customer (
    role,
    email,
    phone,
    name,
    location,
    login,
    pass,
    account,
    last_act,
    blocked
  ) values (
    ${entry.value('role').str},
    ${entry.value('email').str},
    ${entry.value('phone').str},
    ${entry.value('name').str},
    ${entry.value('location').str},
    ${entry.value('login').str},
    ${entry.value('pass').str},
    ${entry.value('account').str},
    ${entry.value('last_act').str},
    ${entry.value('blocked').str}
  );
""");
}