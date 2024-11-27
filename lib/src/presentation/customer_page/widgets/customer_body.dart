import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
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
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<CustomerBody> createState() => _CustomerBodyState(
    authToken: _authToken,
    user: _user,
  );
}
///
///
class _CustomerBodyState extends State<CustomerBody> {
  late final Log _log;
  final String _authToken;
  final AppUser _user;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
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
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final editableRole = [AppUserRole.admin].contains(_user.role);
    final editableLogin = [AppUserRole.admin].contains(_user.role);
    final editablePass = [AppUserRole.admin].contains(_user.role);
    final editableAccount = [AppUserRole.admin].contains(_user.role);
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
            builder: (_) => EditCustomerForm(user: _user),
          ).then((result) {
            _log.debug('.build | new entry: $result');
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
          final toBeUpdated = schema.entries.where(
            (e) {
              return e.isSelected;
            },
          ).toList();
          return showDialog<Result<EntryCustomer, void>?>(
            context: context, 
            builder: (_) => EditCustomerForm(user: _user, entry: toBeUpdated.lastOrNull),
          ).then((result) {
            _log.debug('.build | edited entry: $result');
            return switch (result) {
              Ok(:final value) => Ok(value),
              Err(:final error) => Err(error),
              _ => const Err(null),
            };
          });
        }, 
        icon: const Icon(Icons.add),
      ),      
      delAction: TableWidgetAction(
        onPressed: (schema) {
          final toBeDeleted = schema.entries.firstWhereOrNull((e) {
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
      schema: TableSchema<EntryCustomer, void>(
        read: SqlRead<EntryCustomer, void>(
          address: _apiAddress, 
          authToken: _authToken, 
          database: _database, 
          keepAlive: false,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select * from customer order by id;');
          },
          entryBuilder: (row) {
            _log.debug('.build.entryBuilder | row: $row');
            final entry = EntryCustomer.from(row);
            _log.debug('.build.entryBuilder | entry: $entry');
            return entry;
          },
          debug: true,
        ),
        write: SqlWrite<EntryCustomer>(
          address: _apiAddress, 
          authToken: _authToken, 
          database: _database, 
          keepAlive: true,
          updateSqlBuilder: EntryCustomer.updateSqlBuilder,
          insertSqlBuilder: EntryCustomer.insertSqlBuilder,
          deleteSqlBuilder: EntryCustomer.deleteSqlBuilder,
          emptyEntryBuilder: EntryCustomer.empty,
          debug: true,
        ),
        fields: [
          const Field(hidden: false, editable: false, key: 'id'),
          Field(hidden: false, editable: editableRole, key: 'role'),
          const Field(hidden: false, editable: true, key: 'email'),
          const Field(hidden: false, editable: true, key: 'phone'),
          const Field(hidden: false, editable: true, key: 'name'),
          const Field(hidden: false, editable: true, key: 'location'),
          Field(hidden: false, editable: editableLogin, key: 'login'),
          Field(hidden: false, editable: editablePass, key: 'pass'),
          Field(hidden: false, editable: editableAccount, key: 'account'),
          const Field(hidden: false, editable: true, key: 'last_act'),
          const Field(hidden: false, editable: true, key: 'blocked'),
          const Field(hidden: true, editable: true, key: 'created'),
          const Field(hidden: true, editable: true, key: 'updated'),
          const Field(hidden: true, editable: true, key: 'deleted'),
        ],
      ),
    );
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