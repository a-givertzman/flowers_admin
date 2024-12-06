import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product_category.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/product_page/widgets/edit_product_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class ProductBody extends StatefulWidget {
  final String _authToken;
  ///
  ///
  const ProductBody({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<ProductBody> createState() => _ProductBodyState(
    authToken: _authToken,
  );
}
//
//
class _ProductBodyState extends State<ProductBody> {
  late final Log _log;
  final String _authToken;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final RelationSchema<EntryProduct, void> _schema;
  //
  //
  _ProductBodyState({
    required String authToken,
  }):
    _authToken = authToken {
      _log = Log("$runtimeType");
    }
  //
  //
  @override
  void initState() {
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
          authToken: _authToken, 
          database: _database, 
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select * from product_view order by id;');
          },
          entryBuilder: (row) => EntryProduct.from(row),
          debug: true,
        ),
        write: SqlWrite<EntryProduct>.keep(
          address: _apiAddress, 
          authToken: _authToken, 
          database: _database, 
          updateSqlBuilder: EntryProduct.updateSqlBuilder,
          // insertSqlBuilder: insertSqlBuilderProduct,
          emptyEntryBuilder: EntryProduct.empty, 
          debug: true,
        ),
        fields: [
          const Field(hidden: false, editable: false, key: 'id'),
          const Field(hidden: false, editable: true, title: 'Category', key: 'product_category_id', relation: Relation(id: 'product_category_id', field: 'name')),
          const Field(hidden: false, editable: true, title: 'Name', key: 'name'),
          const Field(hidden: false, editable: true, key: 'details'),
          const Field(hidden: false, editable: true, key: 'primary_price'),
          const Field(hidden: false, editable: true, key: 'primary_currency'),
          const Field(hidden: false, editable: true, key: 'primary_order_quantity'),
          const Field(hidden: false, editable: true, key: 'order_quantity'),
          const Field(hidden: false, editable: true, key: 'description'),
          const Field(hidden: false, editable: true, key: 'picture'),
          const Field(hidden: true, editable: true, key: 'created'),
          const Field(hidden: true, editable: true, key: 'updated'),
          const Field(hidden: true, editable: true, key: 'deleted'),
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
          authToken: _authToken, 
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
          final toBeUpdated = schema.entries.where((e) => e.isSelected).toList();
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
        }, 
        icon: const Icon(Icons.add),
      ),      
      delAction: TableWidgetAction(
        onPressed: (schema) {
          final toBeDeleted = schema.entries.firstWhere(
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
