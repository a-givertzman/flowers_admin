import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/product/entry_product_category.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
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
  final _log = Log("$_EditProductCategoryFormState");
  // final List<Field> _fields;
  // final EntryProduct _entry;
  // final Map<String, List<SchemaEntryAbstract>> _relations;
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
    final EntryProductCategory entry = widget.entry ?? EntryProductCategory.empty();
    final relations = widget.relations;
    final categoryField = _field('category_id', fields);
    _log.debug('.build | categoryField: $categoryField');
    _log.debug('.build | _relations: $relations');
    EditListEntry relation = EditListEntry(entries: [], field: categoryField.relation.field);
    final List<SchemaEntryAbstract>? relEntries = relations[categoryField.relation.id];
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
              Text('${InRu('Edit customer')} ${entry.value('name')}', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        LoadImageWidget(
                          labelText: _field('picture', fields).title.inRu,
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
                        TCellList(
                          id: '${entry.value('category_id').value}',
                          relation: relation,
                          editable: categoryField.isEditable,
                          // style: textStyle,
                          // labelText: field('category').title.inRu,
                          onComplete: (value) {
                            entry.update('category_id', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field('name', fields).title.inRu,
                          value: '${entry.value('name').value}',
                          onComplete: (value) {
                            entry.update('name', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field('details', fields).title.inRu,
                          value: '${entry.value('details').value}',
                          onComplete: (value) {
                            entry.update('details', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field('description', fields).title.inRu,
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
                      Navigator.pop(context, const Err<EntryProductCategory, void>(null));
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: entry.isChanged 
                      ? () {
                        _log.debug('.TextButton.Yes | _isChanged: ${entry.isChanged}');
                        _log.debug('.TextButton.Yes | enrty: $entry');
                        Navigator.pop(context, Ok<EntryProductCategory, void>(entry));
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
