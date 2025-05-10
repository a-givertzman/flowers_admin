import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/purchase/purchase_status.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_edit_date_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/purchase_page/widgets/edit_purchase_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:intl/intl.dart';
///
///
class PurchaseBody extends StatefulWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const PurchaseBody({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<PurchaseBody> createState() => _PurchaseBodyState();
}
//
//
class _PurchaseBodyState extends State<PurchaseBody> {
  late final Log _log;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final TableSchema<EntryPurchase, void> _schema;
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _schema = _buildSchema();
    super.initState();
  }
  ///
  /// Returns TableSchema
  TableSchema<EntryPurchase, void> _buildSchema() {
    return TableSchema<EntryPurchase, void>(
      read: SqlRead<EntryPurchase, void>.keep(
        address: _apiAddress,
        authToken: widget.authToken,
        database: _database,
        sqlBuilder: (sql, params) {
          return Sql(sql: 'select * from purchase order by id;');
        },
        entryBuilder: (row) => EntryPurchase.from(row),
        debug: true,
      ),
      write: SqlWrite<EntryPurchase>.keep(
        address: _apiAddress,
        authToken: widget.authToken,
        database: _database,
        updateSqlBuilder: EntryPurchase.updateSqlBuilder,
        insertSqlBuilder: EntryPurchase.insertSqlBuilder,
        deleteSqlBuilder: EntryPurchase.deleteSqlBuilder,
        emptyEntryBuilder: EntryPurchase.empty,
        debug: true,
      ),
      fields: [
        const Field(flex: 03, hidden: false, editable: false,                             key: 'id'),
              Field(flex: 10, hidden: false, editable: true, title: 'Name'.inRu,          key: 'name'),
              Field(flex: 20, hidden: false, editable: true, title: 'Details'.inRu,       key: 'details'),
              Field(flex: 07, hidden: false, editable: true, title: 'Status'.inRu,        key: 'status', builder: _statusBuilder),
              Field(flex: 10, hidden: false, editable: true, title: 'Date of start'.inRu, key: 'date_of_start', builder: (ctx, entry, onComplite) => _dateBuilder(ctx, entry, onComplite, 'date_of_start')),
              Field(flex: 10, hidden: false, editable: true, title: 'Date of end'.inRu,   key: 'date_of_end', builder: (ctx, entry, onComplite) => _dateBuilder(ctx, entry, onComplite, 'date_of_end')),
              Field(flex: 20, hidden: false, editable: true, title: 'Description'.inRu,   key: 'description'),
              Field(flex: 10, hidden: false, editable: true, title: 'Picture'.inRu,       key: 'picture'),
        const Field(flex: 05, hidden: true, editable: true, title: 'created',             key: 'created'),
        const Field(flex: 05, hidden: true, editable: true, title: 'updated',             key: 'updated'),
        const Field(flex: 05, hidden: true, editable: true, title: 'deleted',             key: 'deleted'),
      ],
    );
  }
  ///
  /// PerchaseStatus field builder
  Widget _statusBuilder(BuildContext ctx, EntryPurchase entry, Function(String)? onComplite) {
    final statusRelation = PurchaseStatus.relation;
    return TEditListWidget(
      id: '${entry.value('status').value}',
      relation: EditListEntry(field: 'status', entries: statusRelation.values.toList()),
      editable: [AppUserRole.admin, AppUserRole.operator].contains(widget.user.role),
      onComplete: (id) {
        final status = statusRelation[id]?.value('status').value;
        _log.debug('build.onComplete | status: $status');
        if (status != null) {
          entry.update('status', status);
          if (onComplite != null) onComplite(status);
        }
      },
    );
  }
  ///
  /// Purchase start/end date field builder
  Widget _dateBuilder(BuildContext ctx, EntryPurchase entry, Function(String)? onComplite, String field) {
    return TEditDateWidget(
      value: '${entry.value(field).value}',
      onComplete: (value) {
        final date = DateFormat('dd-MM-yyyy').tryParse(value);
        entry.update(field, value);
        if (entry.isValid == null && onComplite != null) onComplite(date?.toIso8601String() ?? '');
      },
    );
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    return TableWidget<EntryPurchase, void>(
      schema: _schema,
      showDeleted: [AppUserRole.admin].contains(widget.user.role) ? false : null,
      fetchAction: TableWidgetAction(
        onPressed: (schema) {
          return Future.value(Ok(EntryPurchase.empty()));
        }, 
        icon: const Icon(Icons.add),
      ),
      addAction: TableWidgetAction(
        onPressed: (schema) {
          return showDialog<Result<EntryPurchase, void>?>(
            context: context, 
            builder: (_) => EditPurchaseForm(user: widget.user, fields: schema.fields, relations: schema.relations),
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
          final toBeUpdated = schema.entries.values.where((e) => e.isSelected).toList();
          if (toBeUpdated.isNotEmpty) {
            return showDialog<Result<EntryPurchase, void>?>(
              context: context, 
              builder: (_) => EditPurchaseForm(user: widget.user, fields: schema.fields, entry: toBeUpdated.lastOrNull, relations: schema.relations),
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
          final toBeDeleted = schema.entries.values.firstWhere(
            (e) {
              return e.isSelected;
            },
            orElse: () => EntryPurchase.empty(),
          );
          return showConfirmDialog(
            context, 
            const Text('Delete Purchase ?'), 
            Text('Are you sure want to delete following:\n${toBeDeleted.value('name').str}'),
          ).then((value) {
            return switch (value) {
              Ok() => Ok(toBeDeleted),
              Err(:final error) => Err(error),
            };
          });
        },
        icon: const Icon(Icons.add),
      ),
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
