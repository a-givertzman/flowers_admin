import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
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
  State<EditPurchaseItemForm> createState() => _EditProductFormState();
}
//
//
class _EditProductFormState extends State<EditPurchaseItemForm> {
  late final Log _log;
  late EntryProduct _entry;
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _entry = widget.entry ?? EntryProduct.empty();
    super.initState();
  }
  ///
  ///
  Field _field(List<Field> fields, String key) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field(key: key) as Field<EntryProduct>;
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final categoryField = _field(widget.fields, 'product_category_id');
    _log.debug('.build | categoryField: $categoryField');
    _log.trace('.build | relations: ${widget.relations}');
    final relation = EditListEntry(
      entries: widget.relations[categoryField.relation.id] ?? [],
      field: categoryField.relation.field,
    );
    _log.debug('.build | relation: $relation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${_entry.value('name').value}', style: Theme.of(context).textTheme.titleLarge,),
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
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: OverflowBar(
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
                    _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    _log.debug('.TextButton.Yes | enrty: $_entry');
                    Navigator.pop(context, Ok<EntryProduct, void>(_entry));
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
