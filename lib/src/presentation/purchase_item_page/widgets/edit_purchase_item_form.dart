import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
///
class EditPurchaseItemForm extends StatefulWidget {
  final List<Field> _fields;
  final EntryProduct? _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  ///
  ///
  const EditPurchaseItemForm({
    super.key,
    required List<Field> fields,
    EntryProduct? entry,
    Map<String, List<SchemaEntryAbstract>> relations = const {},
  }):
    _fields = fields,
    _entry = entry,
    _relations = relations;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditPurchaseItemForm> createState() => _EditPurchaseItemFormState(
    fields: _fields,
    entry: _entry ?? EntryProduct.empty(),
    relations: _relations,
  );
}
//
//
class _EditPurchaseItemFormState extends State<EditPurchaseItemForm> {
  final _log = Log("$_EditPurchaseItemFormState._");
  final List<Field> _fields;
  final EntryProduct _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  ///
  ///
  _EditPurchaseItemFormState({
    required List<Field> fields,
    required EntryProduct entry,
    required Map<String, List<SchemaEntryAbstract>> relations,
  }):
    _fields = fields,
    _entry = entry,
    _relations = relations;
  ///
  ///
  Field field(String key) {
    return _fields.firstWhere((element) => element.key == key, orElse: () {
      return Field(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final categoryField = field('product_category_id');
    _log.debug('.build | categoryField: $categoryField');
    _log.debug('.build | _relations: $_relations');
    EditListEntry relation = EditListEntry(entries: [], field: categoryField.relation.field);
    final List<SchemaEntryAbstract>? relEntries = _relations[categoryField.relation.id];
    if (relEntries != null) {
      relation = EditListEntry(entries: relEntries, field: categoryField.relation.field);
    }
    _log.debug('.build | relation: $relation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${InRu('Edit customer')} ${_entry.value('name')}', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                                LoadImageWidget(
                                  labelText: field('picture').title.inRu,
                                  src: '${_entry.value('picture').value}',
                                  onComplete: (value) {
                                    _entry.update('picture', value);
                                    setState(() {return;});
                                  },
                                ),
                    
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                                TCellList(
                                  id: '${_entry.value('product_category_id').value}',
                                  relation: relation,
                                  editable: categoryField.isEditable,
                                  // style: textStyle,
                                  // labelText: field('category').title.inRu,
                                  onComplete: (value) {
                                    _entry.update('product_category_id', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('name').title.inRu,
                                  value: '${_entry.value('name').value}',
                                  onComplete: (value) {
                                    _entry.update('name', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('details').title.inRu,
                                  value: '${_entry.value('details').value}',
                                  onComplete: (value) {
                                    _entry.update('details', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('primary_price').title.inRu,
                                  value: '${_entry.value('primary_price').value}',
                                  onComplete: (value) {
                                    _entry.update('primary_price', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('primary_currency').title.inRu,
                                  value: '${_entry.value('primary_currency').value}',
                                  onComplete: (value) {
                                    _entry.update('primary_currency', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('primary_order_quantity').title.inRu,
                                  value: '${_entry.value('primary_order_quantity').value}',
                                  onComplete: (value) {
                                    _entry.update('primary_order_quantity', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('order_quantity').title.inRu,
                                  value: '${_entry.value('order_quantity').value}',
                                  onComplete: (value) {
                                    _entry.update('order_quantity', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('description').title.inRu,
                                  value: '${_entry.value('description').value}',
                                  onComplete: (value) {
                                    _entry.update('description', value);
                                    setState(() {return;});
                                  },
                                ),                      
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:  () {
                      Navigator.pop(context, const Err<EntryProduct, void>(null));
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: _entry.isChanged 
                      ? () {
                        _log.debug('.TextButton.Yes | _isChanged: ${_entry.isChanged}');
                        _log.debug('.TextButton.Yes | enrty: $_entry');
                        Navigator.pop(context, Ok<EntryProduct, void>(_entry));
                      } 
                      : null,
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
