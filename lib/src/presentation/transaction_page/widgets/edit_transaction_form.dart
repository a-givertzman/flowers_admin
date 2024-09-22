import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_transaction.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
///
class EditTransactionForm extends StatefulWidget {
  final List<Field> _fields;
  final EntryTransaction? _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  ///
  ///
  const EditTransactionForm({
    super.key,
    required List<Field> fields,
    EntryTransaction? entry,
    Map<String, List<SchemaEntryAbstract>> relations = const {},
  }):
    _fields = fields,
    _entry = entry,
    _relations = relations;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditTransactionForm> createState() => _EditProductFormState(
    fields: _fields,
    entry: _entry ?? EntryTransaction.empty(),
    relations: _relations,
  );
}
///
///
class _EditProductFormState extends State<EditTransactionForm> {
  final _log = Log("$_EditProductFormState._");
  final List<Field> _fields;
  final EntryTransaction _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  ///
  ///
  _EditProductFormState({
    required List<Field> fields,
    required EntryTransaction entry,
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
    final authorField = field('author_id');
    _log.debug('.build | authorField: $authorField');
    _log.debug('.build | _relations: $_relations');
    EditListEntry relation = EditListEntry(entries: [], field: authorField.relation.field);
    final List<SchemaEntryAbstract>? relEntries = _relations[authorField.relation.id];
    if (relEntries != null) {
      relation = EditListEntry(entries: relEntries, field: authorField.relation.field);
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
              Text('${InRu('Edit transaction')} [${_entry.value('id').str}] ${InRu('from')} ${_entry.value('created').str}', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                                TCellList(
                                  labelText: '${InRu('Author')}',
                                  id: '${_entry.value('author_id').value}',
                                  relation: relation,
                                  editable: authorField.isEditable,
                                  // style: textStyle,
                                  // labelText: field('category').title.inRu(),
                                  onComplete: (value) {
                                    _entry.update('author_id', value);
                                    setState(() {return;});
                                  },
                                ),
                                // TextEditWidget(
                                //   labelText: field('name').title.inRu(),
                                //   value: '${_entry.value('name').value}',
                                //   onComplete: (value) {
                                //     _entry.update('name', value);
                                //     setState(() {return;});
                                //   },
                                // ),
                                TextEditWidget(
                                  labelText: field('details').title.inRu(),
                                  value: '${_entry.value('details').value}',
                                  onComplete: (value) {
                                    _entry.update('details', value);
                                    setState(() {return;});
                                  },
                                ),
                                TextEditWidget(
                                  labelText: field('value').title.inRu(),
                                  value: '${_entry.value('value').value}',
                                  onComplete: (value) {
                                    _entry.update('value', value);
                                    setState(() {return;});
                                  },
                                ),
                                // TextEditWidget(
                                //   labelText: field('primary_currency').title.inRu(),
                                //   value: '${_entry.value('primary_currency').value}',
                                //   onComplete: (value) {
                                //     _entry.update('primary_currency', value);
                                //     setState(() {return;});
                                //   },
                                // ),
                                TextEditWidget(
                                  labelText: field('description').title.inRu(),
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
                      Navigator.pop(context, const Err<EntryTransaction, void>(null));
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: _entry.isChanged 
                      ? () {
                        _log.debug('.TextButton.Yes | _isChanged: ${_entry.isChanged}');
                        _log.debug('.TextButton.Yes | enrty: $_entry');
                        Navigator.pop(context, Ok<EntryTransaction, void>(_entry));
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
