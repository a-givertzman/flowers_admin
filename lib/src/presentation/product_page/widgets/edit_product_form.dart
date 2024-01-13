import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_product.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
///
class EditProductForm extends StatefulWidget {
  final EntryProduct? _entry;
  ///
  ///
  const EditProductForm({
    super.key,
    EntryProduct? entry,
  }):
    _entry = entry;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditProductForm> createState() => _EditProductFormState(
    entry: _entry ?? EntryProduct.empty(),
  );
}
///
///
class _EditProductFormState extends State<EditProductForm> {
  final _log = Log("$_EditProductFormState._");
  final EntryProduct _entry;
  ///
  ///
  _EditProductFormState({
    required EntryProduct entry,
  }):
    _entry = entry;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${InRu('Edit customer')} ${_entry.value('name')}', style: Theme.of(context).textTheme.titleLarge,),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    LoadImageWidget(
                      labelText: 'picture'.inRu(),
                      src: '${_entry.value('picture').value}',
                      onComplete: (value) {
                        _entry.update('picture', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'category'.inRu(),
                      value: '${_entry.value('product_category_id').value}',
                      onComplete: (value) {
                        _entry.update('product_category_id', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'name'.inRu(),
                      value: '${_entry.value('name').value}',
                      onComplete: (value) {
                        _entry.update('name', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'details'.inRu(),
                      value: '${_entry.value('details').value}',
                      onComplete: (value) {
                        _entry.update('details', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'primary_price'.inRu(),
                      value: '${_entry.value('primary_price').value}',
                      onComplete: (value) {
                        _entry.update('primary_price', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'primary_currency'.inRu(),
                      value: '${_entry.value('primary_currency').value}',
                      onComplete: (value) {
                        _entry.update('primary_currency', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'primary_order_quantity'.inRu(),
                      value: '${_entry.value('primary_order_quantity').value}',
                      onComplete: (value) {
                        _entry.update('primary_order_quantity', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'order_quantity'.inRu(),
                      value: '${_entry.value('order_quantity').value}',
                      onComplete: (value) {
                        _entry.update('order_quantity', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: 'description'.inRu(),
                      value: '${_entry.value('description').value}',
                      onComplete: (value) {
                        _entry.update('description', value);
                        setState(() {return;});
                      },
                    ),
                  ],
                ),
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
