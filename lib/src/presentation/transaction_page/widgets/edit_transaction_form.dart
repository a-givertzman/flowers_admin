import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_transaction.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class EditTransactionForm extends StatefulWidget {
  final AppUser _user;
  final List<Field> _fields;
  final EntryTransaction? _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  ///
  ///
  const EditTransactionForm({
    super.key,
    required AppUser user,
    required List<Field> fields,
    EntryTransaction? entry,
    Map<String, List<SchemaEntryAbstract>> relations = const {},
  }):
    _user = user,
    _fields = fields,
    _entry = entry,
    _relations = relations;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditTransactionForm> createState() => _EditProductFormState(
    user: _user,
    fields: _fields,
    entry: _entry ?? EntryTransaction.empty(),
    relations: _relations,
  );
}
///
///
class _EditProductFormState extends State<EditTransactionForm> {
  final _log = Log("$_EditProductFormState");
  final AppUser _user;
  final List<Field> _fields;
  final EntryTransaction _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  ///
  ///
  _EditProductFormState({
    required AppUser user,
    required List<Field> fields,
    required EntryTransaction entry,
    required Map<String, List<SchemaEntryAbstract>> relations,
  }):
    _user = user,
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
    final customerField = field('customer_id');
    _log.debug('.build | authorField: $authorField');
    _log.debug('.build | customerField: $customerField');
    _log.debug('.build | _relations: $_relations');
    EditListEntry authorRelation = EditListEntry(entries: [], field: authorField.relation.field);
    final List<SchemaEntryAbstract>? authorRelEntries = _relations[authorField.relation.id];
    if (authorRelEntries != null) {
      authorRelation = EditListEntry(entries: authorRelEntries, field: authorField.relation.field);
    }
    _log.debug('.build | authorRelation: $authorRelation');
    EditListEntry customerRelation = EditListEntry(entries: [], field: customerField.relation.field);
    final List<SchemaEntryAbstract>? customerRelEntries = _relations[customerField.relation.id];
    if (customerRelEntries != null) {
      customerRelation = EditListEntry(entries: customerRelEntries, field: customerField.relation.field);
    }
    _log.debug('.build | customerRelation: $customerRelation');
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
                          relation: authorRelation,
                          editable: authorField.isEditable,
                          onComplete: (value) {
                            _entry.update('author_id', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: field('value').title.inRu(),
                          value: '${_entry.value('value').value}',
                          editable: field('value').isEditable,
                          onComplete: (value) {
                            _entry.update('value', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: field('details').title.inRu(),
                          value: '${_entry.value('details').value}',
                          editable: field('details').isEditable,
                          onComplete: (value) {
                            _entry.update('details', value);
                            setState(() {return;});
                          },
                        ),
                        TCellList(
                          labelText: '${InRu('Customer')}',
                          id: '${_entry.value('customer_id').value}',
                          relation: customerRelation,
                          editable: customerField.isEditable,
                          onComplete: (value) {
                            _entry.update('customer_id', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: field('customer_account').title.inRu(),
                          value: '${_entry.value('customer_account').value}',
                          editable: field('customer_account').isEditable,
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
                          editable: field('description').isEditable,
                          onComplete: (value) {
                            _entry.update('description', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: field('created').title.inRu(),
                          value: '${_entry.value('created').value}',
                          editable: field('created').isEditable,
                        ),
                        TextEditWidget(
                          labelText: field('updated').title.inRu(),
                          value: '${_entry.value('updated').value}',
                          editable: field('updated').isEditable,
                        ),
                        if (_entry.value('deleted').value != null)
                          TextEditWidget(
                            labelText: field('deleted').title.inRu(),
                            value: '${_entry.value('deleted').value}',
                            editable: field('deleted').isEditable,
                          ),
                        if ([AppUserRole.admin].contains(_user.role))
                          Checkbox(
                            semanticLabel: 'Allow indebted'.inRu(),
                            value: _entry.value('allow_indebted').value ?? false, 
                            onChanged: (value) {
                              _entry.update('allow_indebted', value ?? false);
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
