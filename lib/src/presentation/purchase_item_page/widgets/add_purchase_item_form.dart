import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
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
class AddPurchaseItemForm extends StatefulWidget {
  final List<Field> fields;
  final EntryPurchaseItem? entry;
  final Map<String, List<SchemaEntryAbstract>> relations;
  ///
  ///
  const AddPurchaseItemForm({
    super.key,
    required this.fields,
    this.entry,
    this.relations = const {},
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<AddPurchaseItemForm> createState() => _AddPurchaseItemFormState();
}
//
//
class _AddPurchaseItemFormState extends State<AddPurchaseItemForm> {
  late final Log _log;
  late EntryPurchaseItem _entry;
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _entry = widget.entry ?? EntryPurchaseItem.empty();
    super.initState();
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
    final statusRelation = PurchaseStatus.values.asMap().map((i, role) {
      return MapEntry(role.str, EntryPurchase(map: {'id': FieldValue(role.str), 'status': FieldValue(role.str)}));
    },);
    final purchaseField = _field(widget.fields, 'purchase_id');
    final purchaseRelation = EditListEntry(
      entries: widget.relations[purchaseField.relation.id] ?? [],
      field: purchaseField.relation.field,
    );
    final productField = _field(widget.fields, 'product_id');
    final productRelation = EditListEntry(
      entries: widget.relations[productField.relation.id] ?? [],
      field: productField.relation.field,
    );
    _log.debug('.build | purchaseRelation: $purchaseRelation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${_entry.value('purchase').value}  >  ${_entry.value('product').value}', style: Theme.of(context).textTheme.titleLarge,),
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
                    src: '${_entry.value('picture').value}',
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
                          if (status != null) {
                            _entry.update('status', status);
                            setState(() {return;});
                          }
                        },
                      ),
                      EditListWidget(
                        id: '${_entry.value('product_id').value}',
                        relation: productRelation,
                        editable: true, //purchaseField.isEditable,
                        // style: textStyle,
                        labelText: productField.title.inRu,
                        onComplete: (value) {
                          _log.trace('build.onComplete | product_id: $value');
                          _entry.update('product_id', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field(widget.fields, 'product').title.inRu,
                        value: '${_entry.value('product').value}',
                        onComplete: (value) {
                          _entry.update('product', value);
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
                        labelText: _field(widget.fields, 'details').title.inRu,
                        value: '${_entry.value('details').value}',
                        editable: _field(widget.fields, 'details').isEditable,
                        onComplete: (value) {
                          _entry.update('details', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field(widget.fields, 'description').title.inRu,
                        value: '${_entry.value('description').value}',
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
          child: OverflowBar(
            children: [
              TextButton(
                onPressed:  () {
                  Navigator.pop(context, const Err<EntryPurchaseItem, void>(null));
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: _entry.isChanged && (_entry.isValid == null)
                  ? () {
                    _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    _log.debug('.TextButton.Yes | enrty: $_entry');
                    Navigator.pop(context, Ok<EntryPurchaseItem, void>(_entry));
                  } 
                  : null,
                child: const Text("Yes"),
              ),
              if (_entry.isValid != null) Text(
                '${_entry.isValid}',
                style: TextStyle(color: Colors.red),
                // Theme.of(context).textTheme.bodyMedium?.copyWith(
                //   color: Theme.of(context).colorScheme.error,
                // ) ?? TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
