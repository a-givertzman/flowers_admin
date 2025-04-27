import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product_category.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/form_widget/edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class EditProductCategoryForm extends StatefulWidget {
  final AppUser user;
  final List<Field<EntryProductCategory>> fields;
  final EntryProductCategory? entry;
  final Map<String, List<SchemaEntryAbstract>> relations;
  ///
  ///
  const EditProductCategoryForm({
    super.key,
    required this.user,
    required this.fields,
    this.entry,
    this.relations = const {},
  });
  //
  //
  @override
  State<EditProductCategoryForm> createState() => _EditProductCategoryFormState();
}
//
//
class _EditProductCategoryFormState extends State<EditProductCategoryForm> {
  late final Log _log;
  late EntryProductCategory _entry;
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _entry = widget.entry ?? EntryProductCategory.empty();
    super.initState();
  }
  ///
  ///
  Field<EntryProductCategory> _field(String key, List<Field<EntryProductCategory>> fields) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryProductCategory>(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final fields = widget.fields;
    final relations = widget.relations;
    final categoryField = _field('category_id', fields);
    _log.debug('.build | categoryField: $categoryField');
    _log.trace('.build | relations: $relations');
    // EditListEntry relation = EditListEntry(entries: [], field: categoryField.relation.field);
    final id = _entry.value('id');
    final List<SchemaEntryAbstract>? relEntries = relations[categoryField.relation.id]?.where((e) {
      return e.value('id') != id;
    }).toList();
    final relation = (relEntries != null) 
      ? EditListEntry(entries: relEntries, field: categoryField.relation.field)
      : EditListEntry(entries: [], field: categoryField.relation.field);
    _log.debug('.build | relation: $relation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // title: Text('${InRu('Edit product category')}', style: Theme.of(context).textTheme.titleLarge,),
          title: Text('${_entry.value('name').value}', style: Theme.of(context).textTheme.titleLarge,),
        ),
        body: Card(
          margin: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    LoadImageWidget(
                      labelText: _field('picture', fields).title.inRu,
                      src: '${_entry.value('picture').value ?? ''}',
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
                    EditListWidget(
                      id: '${_entry.value('category_id').value}',
                      relation: relation,
                      editable: categoryField.isEditable,
                      // style: textStyle,
                      labelText: _field('category', fields).title.inRu,
                      onComplete: (value) {
                        _entry.update('category_id', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('name', fields).title.inRu,
                      value: '${_entry.value('name').value}',
                      onComplete: (value) {
                        _entry.update('name', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('details', fields).title.inRu,
                      value: '${_entry.value('details').value}',
                      onComplete: (value) {
                        _entry.update('details', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('description', fields).title.inRu,
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
        ),
        bottomNavigationBar: BottomAppBar(
          child: OverflowBar(
            children: [
              TextButton(
                onPressed:  () => Navigator.pop(context, const Err<EntryProductCategory, void>(null)),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: _entry.isChanged 
                  ? () {
                    _log.debug('.TextButton.Yes | _isChanged: ${_entry.isChanged}');
                    _log.debug('.TextButton.Yes | enrty: $_entry');
                    Navigator.pop(context, Ok<EntryProductCategory, void>(_entry));
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
