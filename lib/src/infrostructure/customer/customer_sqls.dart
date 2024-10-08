
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
///
/// CUSTOMER
Sql updateSqlBuilderCustomer(Sql sql, EntryCustomer entry) {
  if (entry.isEmpty) {
    return Sql(sql: "select ;");
  } else {
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
      """,
    );
  }
}
///
///
Sql insertSqlBuilderCustomer(Sql sql, EntryCustomer entry) {
  if (entry.isEmpty) {
    return Sql(sql: "select ;");
  } else {
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
      """,
    );
  }
}
///
/// Returns delete CUSTOMER Sql 
Sql deleteSqlBuilderCustomer(Sql sql, EntryCustomer entry) {
  if (entry.isEmpty) {
    return Sql(sql: "select ;");
  } else {
    return Sql(sql: """UPDATE customer SET (
        deleted
      ) = (
        CURRENT_TIMESTAMP()
      )
      WHERE id = ${entry.value('id').str};
      """,
    );
  }
}
