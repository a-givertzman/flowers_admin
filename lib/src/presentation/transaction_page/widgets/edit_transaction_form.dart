import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/transaction/entry_transaction.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/form_widget/edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
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
//
//
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
  Field _field(String key) {
    return _fields.firstWhere((element) => element.key == key, orElse: () {
      return Field(key: key) as Field<EntryTransaction>;
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final authorField = _field('author_id');
    final customerField = _field('customer_id');
    _log.debug('.build | authorField: $authorField');
    _log.debug('.build | customerField: $customerField');
    _log.debug('.build | _relations: $_relations');
    final authorRelation = EditListEntry(
      entries: _relations[authorField.relation.id] ?? [],
      field: authorField.relation.field,
    );
    _log.debug('.build | authorRelation: $authorRelation');
    final customerRelation = EditListEntry(
      entries: _relations[customerField.relation.id] ?? [],
      field: customerField.relation.field,
    );
    final created = DateTime.tryParse(_entry.value('created').value?.toString() ?? '') ?? 'No date'.inRu;
    _log.debug('.build | customerRelation: $customerRelation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${InRu('Edit transaction')} [${_entry.value('id').str}] ${InRu('from')} $created', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        EditListWidget(
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
                          labelText: _field('value').title.inRu,
                          value: '${_entry.value('value').value}',
                          editable: _field('value').isEditable,
                          onComplete: (value) {
                            _entry.update('value', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field('details').title.inRu,
                          value: '${_entry.value('details').value}',
                          editable: _field('details').isEditable,
                          onComplete: (value) {
                            _entry.update('details', value);
                            setState(() {return;});
                          },
                        ),
                        EditListWidget(
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
                          labelText: _field('customer_account').title.inRu,
                          value: '${_entry.value('customer_account').value}',
                          editable: _field('customer_account').isEditable,
                        ),
                        // TextEditWidget(
                        //   labelText: field('primary_currency').title.inRu,
                        //   value: '${_entry.value('primary_currency').value}',
                        //   onComplete: (value) {
                        //     _entry.update('primary_currency', value);
                        //     setState(() {return;});
                        //   },
                        // ),
                        TextEditWidget(
                          labelText: _field('description').title.inRu,
                          value: '${_entry.value('description').value}',
                          editable: _field('description').isEditable,
                          onComplete: (value) {
                            _entry.update('description', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field('created').title.inRu,
                          value: '${_entry.value('created').value}',
                          editable: _field('created').isEditable,
                        ),
                        TextEditWidget(
                          labelText: _field('updated').title.inRu,
                          value: '${_entry.value('updated').value}',
                          editable: _field('updated').isEditable,
                        ),
                        if (_entry.value('deleted').value != null)
                          TextEditWidget(
                            labelText: _field('deleted').title.inRu,
                            value: '${_entry.value('deleted').value}',
                            editable: _field('deleted').isEditable,
                          ),
                        if ([AppUserRole.admin].contains(_user.role))
                          CheckboxListTile(
                            enabled: _field('allow_indebted').isEditable,
                            contentPadding: EdgeInsets.zero,
                            title: Text('Allow indebted'.inRu),
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
