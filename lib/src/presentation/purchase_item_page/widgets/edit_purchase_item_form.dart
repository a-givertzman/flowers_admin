import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/infrostructure/purchase/purchase_status.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/form_widget/edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
///
class EditPurchaseItemForm extends StatefulWidget {
  final List<Field> fields;
  final EntryPurchaseItem? entry;
  final Map<String, List<SchemaEntryAbstract>> relations;
  ///
  ///
  const EditPurchaseItemForm({
    super.key,
    required this.fields,
    this.entry,
    this.relations = const {},
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditPurchaseItemForm> createState() => _EditPurchaseItemFormState();
}
//
//
class _EditPurchaseItemFormState extends State<EditPurchaseItemForm> {
  late final Log _log;
  late EntryPurchaseItem _entry;
  String _details = '';
  String _description = '';
  String _picture = '';
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _entry = widget.entry ?? EntryPurchaseItem.empty();
    // _setPurchase();
    // _setProduct();
    super.initState();
  }
  ///
  /// Returns current purchase corresponding to [_entry]
  dynamic get _purchase {
    return widget.relations['purchase_id']?.firstWhere(
      (entry) => entry.value('id').value == _entry.value('purchase_id').value,
      orElse: () => EntryPurchase.empty(),
    ).value('name').value;
  }
  ///
  /// Returns current purchase corresponding to [_entry]
  dynamic get _product {
    return widget.relations['product_id']?.firstWhere(
      (entry) => entry.value('id').value == _entry.value('product_id').value,
      orElse: () => EntryProduct.empty(),
    ).value('name').value;
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
    final textStyle = Theme.of(context).textTheme.titleMedium;
    final statusRelation = PurchaseStatus.values.asMap().map((i, role) {
      return MapEntry(role.str, EntryPurchase(map: {'id': FieldValue(role.str), 'status': FieldValue(role.str)}));
    },);
    final purchaseField = _field(widget.fields, 'purchase_id');
    final purchaseRelation = EditListEntry(
      entries: widget.relations[purchaseField.relation.id] ?? [],
      field: purchaseField.relation.field,
    );
    final productField = _field(widget.fields, 'product_id');
    final productRelation = widget.relations[productField.relation.id] ?? [];
    final products = EditListEntry(
      entries: widget.relations[productField.relation.id] ?? [],
      field: productField.relation.field,
    );
    final productId = '${_entry.value('product_id').value}';
    final relProduct = productRelation.firstWhere((entry) => '${entry.value('id').value}' == productId, orElse: () => EntryProduct.empty());
    _details = _entry.value('details').value ?? '';
    _description = _entry.value('description').value ?? '';
    _picture = _entry.value('picture').value ?? '';
    _log.debug('.build | purchase_id: ${_entry.value('purchase_id').value}');
    _log.trace('.build | purchaseRelation: $purchaseRelation');
    final isValid = _entry.isValid;
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('$_purchase  >  $_product', style: Theme.of(context).textTheme.titleLarge,),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LoadImageWidget(
                    labelText: _field(widget.fields, 'picture').title.inRu,
                    src: _picture.isEmpty ? '${relProduct.value('picture').value}' : _picture,
                    onComplete: (value) {
                      _entry.update('picture', value);
                      setState(() {return;});
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      EditListWidget(
                        id: '${_entry.value('purchase_id').value}',
                        relation: purchaseRelation,
                        editable: true, //purchaseField.isEditable,
                        // style: textStyle,
                        labelText: purchaseField.title.inRu,
                        onComplete: (value) {
                          _log.trace('build.onComplete | purchase_id: $value');
                          _entry.update('purchase_id', value);
                          _entry.update('details', null);
                          _entry.update('description', null);
                          _entry.update('picture', null);
                          setState(() {return;});
                        },
                      ),
                      EditListWidget(
                        id: '${_entry.value('status').value}',
                        relation: EditListEntry(field: 'status', entries: statusRelation.values.toList()),
                        editable: _field(widget.fields, 'status').isEditable,
                        // style: textStyle,
                        labelText: _field(widget.fields, 'status').title.inRu,
                        onComplete: (id) {
                          final status = statusRelation[id]?.value('status').value;
                          _log.debug('build.onComplete | status: $status');
                          _entry.update('status', status);
                          setState(() {return;});
                        },
                      ),
                      EditListWidget(
                        id: '${_entry.value('product_id').value}',
                        relation: products,
                        editable: productField.isEditable,
                        // style: textStyle,
                        labelText: productField.title.inRu,
                        onComplete: (value) {
                          _log.trace('build.onComplete | product_id: $value');
                          _entry.update('product_id', value);
                          _entry.update('', value);
                          _entry.update('', value);
                          _entry.update('', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field(widget.fields, 'sale_price').title.inRu,
                        value: '${_entry.value('sale_price').value}',
                        editable: _field(widget.fields, 'sale_price').isEditable,
                        onComplete: (value) {
                          _entry.update('sale_price', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field(widget.fields, 'sale_currency').title.inRu,
                        value: '${_entry.value('sale_currency').value}',
                        editable: _field(widget.fields, 'sale_currency').isEditable,
                        onComplete: (value) {
                          _entry.update('sale_currency', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field(widget.fields, 'shipping').title.inRu,
                        value: '${_entry.value('shipping').value}',
                        editable: _field(widget.fields, 'shipping').isEditable,
                        onComplete: (value) {
                          _entry.update('shipping', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field(widget.fields, 'remains').title.inRu,
                        value: '${_entry.value('remains').value}',
                        editable: _field(widget.fields, 'remains').isEditable,
                        onComplete: (value) {
                          _entry.update('remains', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _details.isEmpty ? _field(widget.fields, 'details').title.inRu : _details,
                        value: _details.isEmpty ? '${relProduct.value('details').value}' : _details,
                        style: _details.isEmpty 
                          ? textStyle?.copyWith(color: textStyle.color?.withValues(alpha: 0.5))
                          : null,
                        editable: _field(widget.fields, 'details').isEditable,
                        onComplete: (value) {
                          _entry.update('details', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        // labelText: _field(widget.fields, 'description').title.inRu,
                        labelText: _description.isEmpty ? _field(widget.fields, 'description').title.inRu : _description,
                        value: _description.isEmpty ? '${relProduct.value('description').value}' : _description,
                        style: _description.isEmpty 
                          ? textStyle?.copyWith(color: textStyle.color?.withValues(alpha: 0.5))
                          : null,
                        editable: _field(widget.fields, 'description').isEditable,
                        onComplete: (value) {
                          _entry.update('description', value);
                          setState(() {return;});
                        },
                      ),                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isValid != null) ...[
                Text(
                  isValid,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ) ?? TextStyle(color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: VerticalDivider(),
                ),
              ],
              TextButton(
                onPressed:  () {
                  Navigator.pop(context, const Err<EntryPurchaseItem, void>(null));
                },
                child: Text('Cancel'.inRu),
              ),
              TextButton(
                onPressed: _entry.isChanged && (isValid == null)
                  ? () {
                    _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    _log.debug('.TextButton.Yes | enrty: $_entry');
                    Navigator.pop(context, Ok<EntryPurchaseItem, void>(_entry));
                  } 
                  : null,
                child: Text('Yes'.inRu),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
