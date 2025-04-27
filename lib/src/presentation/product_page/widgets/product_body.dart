import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product_category.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/product_page/widgets/edit_product_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
/// View / Edit the dictionary of `Product`'s
class ProductBody extends StatefulWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  /// View / Edit the dictionary of `Product`'s
  const ProductBody({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<ProductBody> createState() => _ProductBodyState();
}
//
//
class _ProductBodyState extends State<ProductBody> {
  late final Log _log;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final RelationSchema<EntryProduct, void> _schema;
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
  RelationSchema<EntryProduct, void> _buildSchema() {
    return RelationSchema<EntryProduct, void>(
      schema: TableSchema<EntryProduct, void>(
        read: SqlRead<EntryProduct, void>.keep(
          address: _apiAddress, 
          authToken: widget.authToken, 
          database: _database, 
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select * from product_view order by id;');
          },
          entryBuilder: (row) => EntryProduct.from(row),
          debug: true,
        ),
        write: SqlWrite<EntryProduct>.keep(
          address: _apiAddress, 
          authToken: widget.authToken, 
          database: _database, 
          updateSqlBuilder: EntryProduct.updateSqlBuilder,
          insertSqlBuilder: EntryProduct.insertSqlBuilder,
          emptyEntryBuilder: EntryProduct.empty, 
          debug: true,
        ),
        fields: [
          const Field(flex: 03, hidden: false, editable: false, key: 'id'),
          const Field(flex: 10, hidden: false, editable: true, title: 'Category', key: 'product_category_id', relation: Relation(id: 'product_category_id', field: 'name')),
          const Field(flex: 10, hidden: false, editable: true, title: 'Name', key: 'name'),
          const Field(flex: 20, hidden: false, editable: true, key: 'details'),
          const Field(flex: 05, hidden: false, editable: true, key: 'primary_price'),
          const Field(flex: 05, hidden: false, editable: true, key: 'primary_currency'),
          const Field(flex: 05, hidden: false, editable: true, key: 'primary_order_quantity'),
          const Field(flex: 05, hidden: false, editable: true, key: 'order_quantity'),
          const Field(flex: 10, hidden: false, editable: true, key: 'description'),
          const Field(flex: 10, hidden: false, editable: true, key: 'picture'),
          const Field(flex: 05, hidden: true, editable: true, key: 'created'),
          const Field(flex: 05, hidden: true, editable: true, key: 'updated'),
          const Field(flex: 05, hidden: true, editable: true, key: 'deleted'),
        ],
      ),
      relations: _buildRelations(),
    );
  }
  ///
  /// Returns Relations
  Map<String, TableSchemaAbstract<SchemaEntryAbstract, dynamic>> _buildRelations() {
    return {
      'product_category_id': TableSchema<EntryProductCategory, void>(
        read: SqlRead<EntryProductCategory, void>.keep(
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
    return TableWidget<EntryProduct, void>(
      showDeleted: [AppUserRole.admin].contains(widget.user.role) ? false : null,
      addAction: TableWidgetAction(
        onPressed: (schema) {
          return showDialog<Result<EntryProduct, void>?>(
            context: context, 
            builder: (_) => EditProductForm(fields: schema.fields,),
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
            return showDialog<Result<EntryProduct, void>?>(
              context: context, 
              builder: (_) => EditProductForm(fields: schema.fields, entry: toBeUpdated.lastOrNull, relations: schema.relations),
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
            orElse: () => EntryProduct.empty(),
          );
          return showConfirmDialog(
            context, 
            const Text('Delete Product'), 
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
