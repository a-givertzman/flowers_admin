import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase_item.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
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
  //
  //
  @override
  void initState() {
    _log = Log('$runtimeType');
    _entry = widget.entry ?? EntryPurchaseItem.empty();
    super.initState();
  }
  ///
  ///
  Field _field(List<Field> fields, String key) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryPurchaseItem>(key: key);
    });
  }
  //
  //
  @override
  Widget build(BuildContext context) {
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
              Text('${InRu('Edit customer')} ${_entry.value('name')}', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        LoadImageWidget(
                          labelText: _field(widget.fields, 'picture').title.inRu,
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
                                  labelText: _field(widget.fields, 'name').title.inRu,
                                  value: '${_entry.value('name').value}',
                                  onComplete: (value) {
                                    _entry.update('name', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: _field(widget.fields, 'details').title.inRu,
                                  value: '${_entry.value('details').value}',
                                  onComplete: (value) {
                                    _entry.update('details', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: _field(widget.fields, 'primary_price').title.inRu,
                                  value: '${_entry.value('primary_price').value}',
                                  onComplete: (value) {
                                    _entry.update('primary_price', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: _field(widget.fields, 'primary_currency').title.inRu,
                                  value: '${_entry.value('primary_currency').value}',
                                  onComplete: (value) {
                                    _entry.update('primary_currency', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: _field(widget.fields, 'primary_order_quantity').title.inRu,
                                  value: '${_entry.value('primary_order_quantity').value}',
                                  onComplete: (value) {
                                    _entry.update('primary_order_quantity', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: _field(widget.fields, 'order_quantity').title.inRu,
                                  value: '${_entry.value('order_quantity').value}',
                                  onComplete: (value) {
                                    _entry.update('order_quantity', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: _field(widget.fields, 'description').title.inRu,
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
            ],
          ),
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
                onPressed: _entry.isChanged 
                  ? () {
                    _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    _log.debug('.TextButton.Yes | enrty: $_entry');
                    Navigator.pop(context, Ok<EntryPurchaseItem, void>(_entry));
                  } 
                  : null,
                child: const Text("Yes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
