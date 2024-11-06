import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product_category.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class ProductCategoryBody extends StatefulWidget {
  final String _authToken;
  ///
  ///
  const ProductCategoryBody({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<ProductCategoryBody> createState() => _ProductCategoryBodyState(
    authToken: _authToken,
  );
}
//
//
class _ProductCategoryBodyState extends State<ProductCategoryBody> {
  late final Log _log;
  final String _authToken;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  //
  //
  _ProductCategoryBodyState({
    required String authToken,
  }):
    _authToken = authToken {
      _log = Log("$runtimeType");
    }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    return TableWidget(
      schema: RelationSchema<EntryProductCategory, void>(
        schema: TableSchema<EntryProductCategory, void>(
          read: SqlRead<EntryProductCategory, void>(
            address: _apiAddress,
            authToken: _authToken,
            database: _database,
            sqlBuilder: (sql, params) {
              return Sql(sql: 'select * from product_category order by id;');
            },
            entryBuilder: (row) =>
                EntryProductCategory.from(row.cast()),
            debug: true,
          ),
          write: SqlWrite<EntryProductCategory>(
            address: _apiAddress,
            authToken: _authToken,
            database: _database,
            updateSqlBuilder: EntryProductCategory.updateSqlBuilder,
            // insertSqlBuilder: EntryProductCategory.insertSqlBuilder,
            emptyEntryBuilder: EntryProductCategory.empty,
            debug: true,
          ),
          fields: [
            const Field(hidden: false, editable: false, key: 'id'),
            const Field(hidden: false, editable: true, key: 'category_id', relation: Relation(id: 'category_id', field: 'name')),
            const Field(hidden: false, editable: true, key: 'name'),
            const Field(hidden: false, editable: true, key: 'details'),
            const Field(hidden: false, editable: true, key: 'description'),
            const Field(hidden: false, editable: true, key: 'picture'),
            const Field(hidden: true, editable: true, key: 'created'),
            const Field(hidden: true, editable: true, key: 'updated'),
            const Field(hidden: true, editable: true, key: 'deleted'),
          ],
        ),
        relations: {
          'category_id': TableSchema<EntryProductCategory, void>(
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
