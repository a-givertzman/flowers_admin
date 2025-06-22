import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
/// Form to edit an order of the customer
class EditCustomerOrderForm extends StatefulWidget {
  final List<Field> fields;
  final EntryCustomerOrder? entry;
  final Map<String, List<SchemaEntryAbstract>> relations;
  ///
  ///
  const EditCustomerOrderForm({
    super.key,
    required this.fields,
    this.entry,
    this.relations = const {},
  });
  //
  //
  @override
  State<EditCustomerOrderForm> createState() => _EditCustomerOrderFormState();
}
//
//
class _EditCustomerOrderFormState extends State<EditCustomerOrderForm> {
  late final Log _log;
  late EntryCustomerOrder _entry;
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _entry = widget.entry ?? EntryCustomerOrder.empty();
    super.initState();
  }
  ///
  /// Returns a field by it's key
  Field _field(String key) {
    return widget.fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryCustomerOrder>(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    // final categoryField = field('product_category_id');
    // _log.debug('.build | categoryField: $categoryField');
    // _log.trace('.build | _relations: $widget.relations');
    // final relation = EditListEntry(
    //   entries: widget.relations[categoryField.relation.id] ?? [],
    //   field: categoryField.relation.field,
    // );
    // _log.debug('.build | relation: $relation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${_entry.value('customer').value}', style: Theme.of(context).textTheme.titleLarge,),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  margin: EdgeInsets.all(16.0),
                  child: LoadImageWidget(
                    labelText: _field('picture').title.inRu,
                    src: '${_entry.value('picture').value}',
                    onComplete: (value) {
                      _entry.update('picture', value);
                      setState(() {return;});
                    },
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
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
                        labelText: _field('customer').title.inRu,
                        value: '${_entry.value('customer').value}',
                        editable: false,
                        onComplete: (value) {
                          _entry.update('customer', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('purchase').title.inRu,
                        value: '${_entry.value('purchase').value}',
                        editable: false,
                        onComplete: (value) {
                          _entry.update('purchase', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('product').title.inRu,
                        value: '${_entry.value('product').value}',
                        editable: false,
                        onComplete: (value) {
                          _entry.update('product', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('count').title.inRu,
                        value: '${_entry.value('count').value}',
                        editable: _field('count').isEditable,
                        onComplete: (value) {
                          _entry.update('count', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('price').title.inRu,
                        value: '${_entry.value('price').value}',
                        editable: false,
                        onComplete: (value) {
                          _entry.update('price', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('shipping').title.inRu,
                        value: '${_entry.value('shipping').value}',
                        editable: false,
                        onComplete: (value) {
                          _entry.update('shipping', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('cost').title.inRu,
                        value: '${_entry.value('cost').value}',
                        editable: false,
                        onComplete: (value) {
                          _entry.update('cost', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('paid').title.inRu,
                        value: '${_entry.value('paid').value}',
                        editable: false,
                        onComplete: (value) {
                          _entry.update('paid', value);
                          setState(() {return;});
                        },
                      ),
                      // TextEditWidget(
                      //   labelText: field('primary_currency').title.inRu,
                      //   value: '${_entry.value('primary_currency').value}',
                      //   onComplete: (value) {
                      //     _entry.update('primary_currency', value);
                      //     setState(() {return;});
                      //   },
                      // ),
                      // TextEditWidget(
                      //   labelText: field('primary_order_quantity').title.inRu,
                      //   value: '${_entry.value('primary_order_quantity').value}',
                      //   onComplete: (value) {
                      //     _entry.update('primary_order_quantity', value);
                      //     setState(() {return;});
                      //   },
                      // ),
                      // TextEditWidget(
                      //   labelText: field('order_quantity').title.inRu,
                      //   value: '${_entry.value('order_quantity').value}',
                      //   onComplete: (value) {
                      //     _entry.update('order_quantity', value);
                      //     setState(() {return;});
                      //   },
                      // ),
                      TextEditWidget(
                        labelText: _field('description').title.inRu,
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
            ],
          ),
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
                    Navigator.pop(context, Ok<EntryCustomerOrder, void>(_entry));
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
