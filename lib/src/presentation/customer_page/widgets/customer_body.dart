import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/customer_page/widgets/edit_customer_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
///
///
class CustomerBody extends StatefulWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const CustomerBody({
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
  State<CustomerBody> createState() => _CustomerBodyState(
    authToken: _authToken,
    user: _user,
  );
}
//
//
class _CustomerBodyState extends State<CustomerBody> {
  late final Log _log;
  final String _authToken;
  final AppUser _user;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final TableSchema<EntryCustomer, void> _schema;
  ///
  ///
  _CustomerBodyState({
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
  _log.debug('.build | Create schema...');
    final editableRole = [AppUserRole.admin].contains(_user.role);
    final editableLogin = [AppUserRole.admin].contains(_user.role);
    final editablePass = [AppUserRole.admin].contains(_user.role);
    final editableAccount = [AppUserRole.admin].contains(_user.role);
    final editableBlocked = [AppUserRole.admin].contains(_user.role);
    _schema = TableSchema<EntryCustomer, void>(
      read: SqlRead<EntryCustomer, void>.keep(
        address: _apiAddress, 
        authToken: _authToken, 
        database: _database, 
        sqlBuilder: (sql, params) {
          return Sql(sql: 'select * from customer order by id;');
        },
        entryBuilder: (row) {
          // _log.debug('.build.entryBuilder | row: $row');
          final entry = EntryCustomer.from(row);
          // _log.debug('.build.entryBuilder | entry: $entry');
          return entry;
        },
        debug: true,
      ),
      write: SqlWrite<EntryCustomer>.keep(
        address: _apiAddress, 
        authToken: _authToken, 
        database: _database, 
        updateSqlBuilder: EntryCustomer.updateSqlBuilder,
        insertSqlBuilder: EntryCustomer.insertSqlBuilder,
        deleteSqlBuilder: EntryCustomer.deleteSqlBuilder,
        emptyEntryBuilder: EntryCustomer.empty,
        debug: true,
      ),
      fields: [
              Field(flex: 03, hidden: false, editable: false, key: 'id'),
              Field(flex: 05, hidden: false, editable: editableRole, key: 'role', title: 'Role'.inRu),
              Field(flex: 15, hidden: false, editable: true, key: 'email', title: 'Email'.inRu),
              Field(flex: 07, hidden: false, editable: true, key: 'phone', title: 'Phone'.inRu),
              Field(flex: 10, hidden: false, editable: true, key: 'name', title: 'Name'.inRu),
              Field(flex: 05, hidden: false, editable: true, key: 'location', title: 'Location'.inRu),
              Field(flex: 15, hidden: false, editable: editableLogin, key: 'login', title: 'Login'.inRu),
              Field(flex: 10, hidden: false, editable: editablePass, key: 'pass', title: 'Pass'.inRu),
              Field(flex: 07, hidden: false, editable: editableAccount, key: 'account', title: 'Account'.inRu),
              Field(flex: 10, hidden: false, editable: false, key: 'last_act', title: 'Last action'.inRu),
              Field(flex: 05, hidden: false, editable: editableBlocked, key: 'blocked', title: 'Blocked'.inRu),
              Field(flex: 05, hidden: true, editable: true, key: 'created', title: 'Created'.inRu),
              Field(flex: 05, hidden: true, editable: true, key: 'updated', title: 'Updated'.inRu),
              Field(flex: 05, hidden: true, editable: true, key: 'deleted', title: 'Deleted'.inRu),
      ],
    );
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    return TableWidget<EntryCustomer, void>(
      showDeleted: [AppUserRole.admin].contains(_user.role) ? false : null,
      fetchAction: TableWidgetAction(
        onPressed: (schema) {
          return Future.value(Ok(EntryCustomer.empty()));
        }, 
        icon: const Icon(Icons.add),
      ),
      addAction: TableWidgetAction(
        onPressed: (schema) {
          return showDialog<Result<EntryCustomer, void>?>(
            context: context, 
            builder: (_) => EditCustomerForm(user: _user, fields: schema.fields),
          ).then((result) {
            // _log.debug('.build | new entry: $result');
            return switch (result) {
              Ok(:final value) => Ok(value),
              Err(:final error) => Err(error),
              _ => const Err(null),
            };
          });
        }, 
        icon: const Icon(Icons.add),
      ),
      editAction: TableWidgetAction(
        onPressed: (schema) {
          final toBeUpdated = schema.entries.values.where((e) {
            return e.isSelected;
          }).toList();
          if (toBeUpdated.isNotEmpty) {
            return showDialog<Result<EntryCustomer, void>?>(
              context: context, 
              builder: (_) => EditCustomerForm(user: _user, fields: schema.fields, entry: toBeUpdated.lastOrNull),
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
      delAction: TableWidgetAction(
        onPressed: (schema) {
          final toBeDeleted = schema.entries.values.firstWhereOrNull((e) {
              return e.isSelected;
          });
          if (toBeDeleted != null) {
            return showConfirmDialog(
              context, 
              const Text('Delete Customer'), 
              Text('Are you sure want to delete following:\n${toBeDeleted.value('name').str}'),
            ).then((value) {
              return switch (value) {
                Ok() => Ok(toBeDeleted),
                Err(:final error) => Err(error),
              };
            });
          }
          return Future.value(const Err(null));
        },
        icon: const Icon(Icons.add),
      ),
      schema: _schema,
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