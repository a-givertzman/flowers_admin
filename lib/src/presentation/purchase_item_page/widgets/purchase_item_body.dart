import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/infrostructure/purchase/purchase_status.dart';
import 'package:flowers_admin/src/presentation/core/form_widget/edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flowers_admin/src/presentation/purchase_item_page/widgets/edit_purchase_item_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class PurchaseItemBody extends StatefulWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const PurchaseItemBody({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<PurchaseItemBody> createState() => _PurchaseItemBodyState();
}
//
//
class _PurchaseItemBodyState extends State<PurchaseItemBody> {
  late final Log _log;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  late final RelationSchema<EntryPurchaseItem, void> _schema;
  String _purchaseId = '';
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
  RelationSchema<EntryPurchaseItem, PurchaseItemSqlParam> _buildSchema() {
    final currencyEditable = [AppUserRole.admin].contains(widget.user.role);
    final remainsEditable = [AppUserRole.admin].contains(widget.user.role);
    return RelationSchema<EntryPurchaseItem, PurchaseItemSqlParam>(
        schema: TableSchema<EntryPurchaseItem, PurchaseItemSqlParam>(
          read: SqlRead<EntryPurchaseItem, PurchaseItemSqlParam>(
            address: _apiAddress,
            authToken: widget.authToken,
            database: _database,
            sqlBuilder: (sql, PurchaseItemSqlParam? params) {
              if (_purchaseId.isNotEmpty) {
                return Sql(sql: 'select * from purchase_item_view where purchase_id = $_purchaseId order by id;');
              }
              return Sql(sql: 'select * from purchase_item_view order by id;');
            },
            entryBuilder: (row) => EntryPurchaseItem.from(row),
            debug: true,
          ),
          write: SqlWrite<EntryPurchaseItem>(
            address: _apiAddress,
            authToken: widget.authToken,
            database: _database,
            updateSqlBuilder: EntryPurchaseItem.updateSqlBuilder,
            insertSqlBuilder: EntryPurchaseItem.insertSqlBuilder,
            emptyEntryBuilder: EntryPurchaseItem.empty,
            debug: true,
          ),
          fields: [
            const Field(flex: 03, hidden: false, editable: false, key: 'id'),
                  Field(flex: 15, hidden: false, editable: false, title: 'Purchase'.inRu, key: 'purchase_id', relation: Relation(id: 'purchase_id', field: 'name')),
                  Field(flex: 05, hidden: false, editable: true, title: 'Status'.inRu, key: 'status', builder: _statusBuilder, hint: 'Статус закупки. \nНаследуется от закупки, если оставить поле пустым, можно изменить для отдельной позиции'),
                  // Field(flex: 15, hidden: false, editable: true, title: 'Prodict'.inRu, key: 'product'),
                  Field(flex: 15, hidden: false, editable: true, title: 'Product'.inRu, key: 'product_id', relation: Relation(id: 'product_id', field: 'name')),
                  Field(flex: 05, hidden: false, editable: true, title: 'Price'.inRu, key: 'sale_price', hint: 'Цена за единицу товара'),
                  Field(flex: 04, hidden: false, editable: currencyEditable, title: 'Currency'.inRu, key: 'sale_currency', hint:'Валюта цены'),
                  Field(flex: 05, hidden: false, editable: true, title: 'Shipping'.inRu, key: 'shipping', hint: 'Цена доставки за единицу товара'),
                  Field(flex: 05, hidden: false, editable: remainsEditable, title: 'Remains'.inRu, key: 'remains', hint: 'Остаток товара на данный момент. \nЕсли статус закупки "Active" может быстро меняться из-за поступления новых заказов'),
                  Field(flex: 15, hidden: false, editable: true, title: 'Details'.inRu, key: 'details', builder: _detailsBuilder, hint: 'Короткое описание. \nНаследуется от закупки, если оставить поле пустым, можно изменить для отдельной позиции'),
                  Field(flex: 20, hidden: false, editable: true, title: 'Description'.inRu, key: 'description', hint: 'Детальное описание. \nНаследуется от закупки, если оставить поле пустым, можно изменить для отдельной позиции'),
                  Field(flex: 10, hidden: false, editable: true, title: 'Picture'.inRu, key: 'picture', hint: 'Ссылка на изображение. \nНаследуется от закупки, если оставить поле пустым, можно изменить для отдельной позиции'),
            const Field(flex: 05, hidden: true, editable: true, key: 'created'),
            const Field(flex: 05, hidden: true, editable: true, key: 'updated'),
            const Field(flex: 05, hidden: true, editable: true, key: 'deleted'),
          ],
        ),
        relations: _buildRelations(),
      );
  }
  ///
  /// PerchaseStatus field builder
  Widget _statusBuilder(BuildContext ctx, EntryPurchaseItem entry, Function(String)? onComplite) {
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
  /// PerchaseStatus field builder
  Widget _detailsBuilder(BuildContext ctx, EntryPurchaseItem entry, Function(String)? onComplite) {
    final detailsRelation = PurchaseStatus.relation;
    return TEditWidget(
      hint: _field(_schema.fields, 'details').title.inRu,
      value: '${entry.value('details').value}',
      editable: [AppUserRole.admin, AppUserRole.operator].contains(widget.user.role),
      onComplete: (id) {
        final details = detailsRelation[id]?.value('details').value;
        _log.debug('build.onComplete | details: $details');
        if (details != null) {
          entry.update('status', details);
          if (onComplite != null) onComplite(details);
        }
      },
    );
  }
  ///
  /// Returns Relations
  _buildRelations() {
    return {
      'purchase_id': TableSchema<EntryPurchase, void>(
        read: SqlRead<EntryPurchase, void>(
          address: _apiAddress,
          authToken: widget.authToken,
          database: _database,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select id, name from purchase order by id;');
          },
          entryBuilder: (row) => EntryPurchase.from(row),
          debug: true,
        ),
        fields: [
          const Field(key: 'id'),
          const Field(key: 'name'),
        ],
      ),
      'product_id': TableSchema<EntryProduct, void>(
        read: SqlRead<EntryProduct, void>(
          address: _apiAddress,
          authToken: widget.authToken,
          database: _database,
          sqlBuilder: (sql, params) {
            return Sql(sql: 'select id, name from product order by id;');
          },
          entryBuilder: (row) => EntryProduct.from(row),
          debug: true,
        ),
        fields: [
          const Field(key: 'id'),
          const Field(key: 'name'),
        ],
      ),
    };
  }
  ///
  ///
  Field _field(List<Field> fields, String key) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryPurchaseItem>(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    final purchaseField = _field(_schema.fields, 'purchase_id');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder(
          stream: _schema.stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            switch (snapshot.data) {
              case Ok(value: _):
                return EditListWidget(
                  id: _purchaseId,
                  relation: EditListEntry(
                    entries: _schema.relations[purchaseField.relation.id] ?? [],
                    field: purchaseField.relation.field,
                  ),
                  editable: [AppUserRole.admin, AppUserRole.operator].contains(widget.user.role),
                  style: Theme.of(context).textTheme.bodyLarge,
                  labelText: _field(_schema.fields, 'purchase_id').title.inRu,
                  onComplete: (purchaseId) {
                    if (purchaseId != _purchaseId) {
                      setState(() {
                        _purchaseId = purchaseId;
                        _log.debug('.build.onComplete | _purchaseId: $_purchaseId');
                      });
                    }
                  },
                );
              case Err(error: _):                
                return CircularProgressIndicator();
              case null:                
                return CircularProgressIndicator();
            }
            return CircularProgressIndicator.adaptive();
          }
        ),
        Expanded(
          child: TableWidget<EntryPurchaseItem, void>(
            schema: _schema,
            showDeleted: [AppUserRole.admin].contains(widget.user.role) ? false : null,
            fetchAction: TableWidgetAction(
              onPressed: (schema) {
                return Future.value(Ok(EntryPurchaseItem.empty()));
              }, 
              icon: const Icon(Icons.add),
            ),
            addAction: TableWidgetAction(
              onPressed: (schema) {
                final entry = EntryPurchaseItem.from({'purchase_id': _purchaseId, 'sale_currency': 'RUB'});
                return showDialog<Result<EntryPurchaseItem, void>?>(
                  context: context, 
                  builder: (_) => EditPurchaseItemForm(fields: schema.fields, entry: entry, relations: schema.relations),
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
                final toBeUpdated = schema.entries.values.where((e) => e.isSelected).toList();
                if (toBeUpdated.isNotEmpty) {
                  return showDialog<Result<EntryPurchaseItem, void>?>(
                    context: context, 
                    builder: (_) => EditPurchaseItemForm(fields: schema.fields, entry: toBeUpdated.lastOrNull, relations: schema.relations),
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
                  orElse: () => EntryPurchaseItem.empty(),
                );
                return showConfirmDialog(
                  context, 
                  const Text('Delete Purchase item ?'), 
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
          ),
        ),
      ],
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
///
///
class PurchaseItemSqlParam {
  String? purchase_id;
  PurchaseItemSqlParam({
    this.purchase_id,
  });
}