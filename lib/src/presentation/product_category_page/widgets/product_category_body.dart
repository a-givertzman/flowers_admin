import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product_category.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/product_category_page/widgets/edit_product_category_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
///
/// View/Edit the categories of the `Product`
class ProductCategoryBody extends StatefulWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const ProductCategoryBody({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  State<ProductCategoryBody> createState() => _ProductCategoryBodyState();
}
//
//
class _ProductCategoryBodyState extends State<ProductCategoryBody> {
  late final Log _log;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final RelationSchema<EntryProductCategory, void> _schema;
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
  RelationSchema<EntryProductCategory, void> _buildSchema() {
    return RelationSchema<EntryProductCategory, void>(
      schema: TableSchema<EntryProductCategory, void>(
        read: SqlRead<EntryProductCategory, void>.keep(
          address: _apiAddress,
          authToken: widget.authToken,
          database: _database,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select * from product_category order by id;');
          },
          entryBuilder: (row) =>
              EntryProductCategory.from(row.cast()),
          debug: true,
        ),
        write: SqlWrite<EntryProductCategory>.keep(
          address: _apiAddress,
          authToken: widget.authToken,
          database: _database,
          updateSqlBuilder: EntryProductCategory.updateSqlBuilder,
          insertSqlBuilder: EntryProductCategory.insertSqlBuilder,
          deleteSqlBuilder: EntryProductCategory.deleteSqlBuilder,
          emptyEntryBuilder: EntryProductCategory.empty,
          debug: true,
        ),
        fields: [
          const Field(flex: 3, hidden: false, editable: false, key: 'id'),
          const Field(flex: 10, hidden: false, editable: true, key: 'category_id', relation: Relation(id: 'category_id', field: 'name')),
          const Field(flex: 10, hidden: false, editable: true, key: 'name'),
          const Field(flex: 20, hidden: false, editable: true, key: 'details'),
          const Field(flex: 20, hidden: false, editable: true, key: 'description'),
          const Field(flex: 10, hidden: false, editable: true, key: 'picture'),
          const Field(flex: 5, hidden: true, editable: true, key: 'created'),
          const Field(flex: 5, hidden: true, editable: true, key: 'updated'),
          const Field(flex: 5, hidden: true, editable: true, key: 'deleted'),
        ],
      ),
      relations: _buildRelations(),
    );
  }
  ///
  /// Returns Relations
  Map<String, TableSchemaAbstract<SchemaEntryAbstract, dynamic>> _buildRelations() {
    return {
      'category_id': TableSchema<EntryProductCategory, void>(
        read: SqlRead<EntryProductCategory, void>(
          address: _apiAddress,
          authToken: widget.authToken,
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
    };
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    return TableWidget<EntryProductCategory, void>(
      showDeleted: [AppUserRole.admin].contains(widget.user.role) ? false : null,
      fetchAction: TableWidgetAction(
        onPressed: (schema) {
          return Future.value(Ok(EntryProductCategory.empty()));
        }, 
        icon: const Icon(Icons.add),
      ),
      addAction: TableWidgetAction(
        onPressed: (schema) {
          return showDialog<Result<EntryProductCategory, void>?>(
            context: context, 
            builder: (_) => EditProductCategoryForm(user: widget.user, fields: schema.fields, relations: schema.relations),
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
            return showDialog<Result<EntryProductCategory, void>?>(
              context: context, 
              builder: (_) => EditProductCategoryForm(user: widget.user, fields: schema.fields, entry: toBeUpdated.lastOrNull, relations: schema.relations),
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
              const Text('Delete Product category'), 
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
