import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
///
class EditPurchaseItemForm extends StatefulWidget {
  final List<Field> fields;
  final EntryProduct? entry;
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
  final _log = Log("$_EditPurchaseItemFormState");
  ///
  ///
  Field field(List<Field> fields, String key) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final entry = widget.entry ?? EntryProduct.empty();
    // final categoryField = field('product_category_id');
    // _log.debug('.build | categoryField: $categoryField');
    // _log.trace('.build | relations: ${widget.relations}');
    // final relation = EditListEntry(
    //   entries: _relations[categoryField.relation.id] ?? [],
    //   field: categoryField.relation.field,
    // );
    // _log.debug('.build | relation: $relation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${InRu('Edit customer')} ${entry.value('name')}', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                                LoadImageWidget(
                                  labelText: field(widget.fields, 'picture').title.inRu,
                                  src: '${entry.value('picture').value}',
                                  onComplete: (value) {
                                    entry.update('picture', value);
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
                                // TODO! Was commented by AL on 6.04.25, to be fixed
                                // EditListWidget(
                                //   id: '${_entry.value('product_category_id').value}',
                                //   relation: relation,
                                //   editable: categoryField.isEditable,
                                //   // style: textStyle,
                                //   // labelText: field('category').title.inRu,
                                //   onComplete: (value) {
                                //     _entry.update('product_category_id', value);
                                //     setState(() {return;});
                                //   },
                                // ),
                                TextEditWidget(
                                  labelText: field(widget.fields, 'name').title.inRu,
                                  value: '${entry.value('name').value}',
                                  onComplete: (value) {
                                    entry.update('name', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field(widget.fields, 'details').title.inRu,
                                  value: '${entry.value('details').value}',
                                  onComplete: (value) {
                                    entry.update('details', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field(widget.fields, 'primary_price').title.inRu,
                                  value: '${entry.value('primary_price').value}',
                                  onComplete: (value) {
                                    entry.update('primary_price', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field(widget.fields, 'primary_currency').title.inRu,
                                  value: '${entry.value('primary_currency').value}',
                                  onComplete: (value) {
                                    entry.update('primary_currency', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field(widget.fields, 'primary_order_quantity').title.inRu,
                                  value: '${entry.value('primary_order_quantity').value}',
                                  onComplete: (value) {
                                    entry.update('primary_order_quantity', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field(widget.fields, 'order_quantity').title.inRu,
                                  value: '${entry.value('order_quantity').value}',
                                  onComplete: (value) {
                                    entry.update('order_quantity', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field(widget.fields, 'description').title.inRu,
                                  value: '${entry.value('description').value}',
                                  onComplete: (value) {
                                    entry.update('description', value);
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
                    onPressed: entry.isChanged 
                      ? () {
                        _log.debug('.TextButton.Yes | _isChanged: ${entry.isChanged}');
                        _log.debug('.TextButton.Yes | enrty: $entry');
                        Navigator.pop(context, Ok<EntryProduct, void>(entry));
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
