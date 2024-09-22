import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_product_category.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
///
class TransactionBody extends StatefulWidget {
  final String _authToken;
  ///
  ///
  const TransactionBody({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<TransactionBody> createState() => _ProductBodyState(
    authToken: _authToken,
  );
}
///
///
class _ProductBodyState extends State<TransactionBody> {
  late final Log _log;
  final String _authToken;
  final _database = 'flowers_app_server';
  final _apiAddress = const ApiAddress(host: '127.0.0.1', port: 8080);
  ///
  ///
  _ProductBodyState({
    required String authToken,
  }):
    _authToken = authToken {
      _log = Log("$runtimeType");
    }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return TableWidget<EntryProduct, void>(
      addAction: TableWidgetAction(
        onPressed: (schema) {
          return showDialog<Result<EntryProduct, void>?>(
            context: context, 
            builder: (_) => const Text('Not implemented'),  // EditProductForm(fields: schema.fields,),
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
            builder: (_) => const Text('Not implemented'),   //EditProductForm(fields: schema.fields, entry: toBeUpdated.lastOrNull, relations: schema.relations),
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
          final toBeDeleted = schema.entries.firstWhere((e) {
            return e.isSelected;
          });
          return showConfirmDialog(
            context, 
            const Text('Delete Product'), 
            Text('Are you sure want to delete following:\n$toBeDeleted'),
          ).then((value) {
            return switch (value) {
              Ok() => Ok(toBeDeleted),
              Err(:final error) => Err(error),
            };
          });
        },
        icon: const Icon(Icons.add),
      ),
      schema: RelationSchema<EntryProduct, void>(
        schema: TableSchema<EntryProduct, void>(
          read: SqlRead<EntryProduct, void>(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database, 
            sqlBuilder: (sql, params) {
              return Sql(sql: 'select * from product_view order by id;');
            },
            entryBuilder: (row) => EntryProduct.from(row),
            debug: true,
          ),
          write: SqlWrite<EntryProduct>(
            address: _apiAddress, 
            authToken: _authToken, 
            database: _database, 
            updateSqlBuilder: updateSqlBuilderProduct,
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
        relations: {
          'product_category_id': TableSchema<EntryProductCategory, void>(
            read: SqlRead<EntryProductCategory, void>(
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
        },
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

///
///
Sql updateSqlBuilderProduct(Sql sql, EntryProduct entry) {
  final m = {
    if (entry.value('id').isChanged) ...{'id': entry.value('id').str},
    if (entry.value('product_category_id').isChanged) ...{'product_category_id': entry.value('product_category_id').str},
    if (entry.value('name').isChanged) ...{'name': entry.value('name').str},
    if (entry.value('details').isChanged) ...{'details': entry.value('details').str},
    if (entry.value('primary_price').isChanged) ...{'primary_price': entry.value('primary_price').str},
    if (entry.value('primary_currency').isChanged) ...{'primary_currency': entry.value('primary_currency').str},
    if (entry.value('primary_order_quantity').isChanged) ...{'primary_order_quantity': entry.value('primary_order_quantity').str},
    if (entry.value('order_quantity').isChanged) ...{'order_quantity': entry.value('order_quantity').str},
    if (entry.value('description').isChanged) ...{'description': entry.value('description').str},
    if (entry.value('picture').isChanged) ...{'picture': entry.value('picture').str},
    if (entry.value('deleted').isChanged) ...{'deleted': entry.value('deleted').str},
  };
  final keys = m.keys.toList().join(',');
  final values = m.values.toList().join(',');
  return Sql(sql: """UPDATE product SET (
    $keys
  ) = (
    $values
  )
  WHERE id = ${entry.value('id').str};
""");
}







// ///
// /// === ORIGINAL ===
// Sql updateSqlBuilderProduct(Sql sql, EntryProduct entry) {
//   return Sql(sql: """UPDATE product SET (
//     id,
//     product_category_id,
//     name,
//     details,
//     primary_price,
//     primary_currency,
//     primary_order_quantity,
//     order_quantity,
//     description,
//     picture,
//     created,
//     updated,
//     deleted
//   ) = (
//     ${entry.value('id').str},
//     ${entry.value('product_category_id').str},
//     ${entry.value('name').str},
//     ${entry.value('details').str},
//     ${entry.value('primary_price').str},
//     ${entry.value('primary_currency').str},
//     ${entry.value('primary_order_quantity').str},
//     ${entry.value('order_quantity').str},
//     ${entry.value('description').str},
//     ${entry.value('picture').str},
//     ${entry.value('created').str},
//     ${entry.value('updated').str},
//     ${entry.value('deleted').str}
//   )
//   WHERE id = ${entry.value('id').str};
// """);
// }