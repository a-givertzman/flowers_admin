import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/transaction/entry_transaction.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class AddTransactionForm extends StatefulWidget {
  final AppUser _user;
  final List<Field> _fields;
  final EntryTransaction? _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  ///
  ///
  const AddTransactionForm({
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
  State<AddTransactionForm> createState() => _AddProductFormState(
    user: _user,
    fields: _fields,
    entry: _entry ?? EntryTransaction.empty(),
    relations: _relations,
  );
}
//
//
class _AddProductFormState extends State<AddTransactionForm> {
  final _log = Log("$_AddProductFormState._");
  final AppUser _user;
  final List<Field> _fields;
  final EntryTransaction _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  String? _customerId;
  String? _customerAccount;
  ///
  ///
  _AddProductFormState({
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
    _entry.update('author_id', _user.id);
    _log.debug('.build | Fields: $_fields');
    final customerField = _field('customer_id');
    _log.debug('.build | customerField: $customerField');
    _log.debug('.build | _relations: $_relations');
    EditListEntry customerRelation = EditListEntry(entries: _relations[customerField.relation.id] ?? [], field: customerField.relation.field);
    _log.debug('.build | customerRelation: $customerRelation');
    _log.debug('.build | _customerId: \'$_customerId\'');
    // _log.debug('.build | _customerAccount: \'$_customerAccount\'');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${InRu('New transaction')}', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextEditWidget(
                          labelText: '${InRu('Author')}',
                          value: '${_user.name} [${_user.id}]',
                          editable: false,
                        ),
                        TextEditWidget(
                          labelText: _field('value').title.inRu,
                          value: '${_entry.value('value').value}',
                          onComplete: (value) {
                            _entry.update('value', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field('details').title.inRu,
                          value: '${_entry.value('details').value}',
                          onComplete: (value) {
                            _entry.update('details', value);
                            setState(() {return;});
                          },
                        ),
                        TCellList(
                          labelText: '${InRu('Customer')}',
                          id: (_entry.value('customer_id').value != null && '${_entry.value('customer_id').value}'.isNotEmpty) ? '${_entry.value('customer_id').value}' : null,
                          relation: customerRelation,
                          editable: true,
                          onComplete: (value) {
                            setState(() {
                              _customerId = value;
                              _customerAccount = EditListEntry(entries: _relations[customerField.relation.id] ?? [], field: 'account').value(_customerId);
                              _entry.update('customer_id', value);
                            });
                          },
                        ),
                        textWithLabel(
                          context: context,
                          labelText: _field('customer_account').title.inRu,
                          value:_customerAccount ?? '',
                          enable: false,
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
                          onComplete: (value) {
                            _entry.update('description', value);
                            setState(() {return;});
                          },
                        ),
                        if ([AppUserRole.admin].contains(_user.role))
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Allow indebted'.inRu),
                            value: _entry.value('allow_indebted').value ?? false, 
                            onChanged: (value) {
                              _entry.update('allow_indebted', value ?? false);
                              setState(() {return;});
                            },
                          ),
                                    
                        // TextEditWidget(
                        //   labelText: field('created').title.inRu,
                        //   value: '${_entry.value('created').value}',
                        //   editable: field('created').isEditable,
                        // ),
                        // TextEditWidget(
                        //   labelText: field('updated').title.inRu,
                        //   value: '${_entry.value('updated').value}',
                        //   editable: field('updated').isEditable,
                        // ),
                        // if (_entry.value('deleted').value != null)
                        //   TextEditWidget(
                        //     labelText: field('deleted').title.inRu,
                        //     value: '${_entry.value('deleted').value}',
                        //     editable: field('deleted').isEditable,
                        //   ),           
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
                        _log.debug('.TextButton.Yes | _isEmpty: ${_entry.isEmpty}');
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
  ///
  /// Returns Text with label looks like TextEditWidget
  Widget textWithLabel({required context, String? labelText, String? value = '', bool enable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((value != null && value.isNotEmpty) && labelText != null && labelText.isNotEmpty)
            Text(
              labelText,
              style: enable
                ? Theme.of(context).inputDecorationTheme.labelStyle ?? Theme.of(context).textTheme.bodySmall
                : (Theme.of(context).inputDecorationTheme.labelStyle ?? Theme.of(context).textTheme.bodySmall)?.copyWith(color: Theme.of(context).disabledColor),
            ),
          Text(
            value != null && value.isNotEmpty ? value : labelText ?? '',
            style: enable
              ? Theme.of(context).textTheme.bodyLarge
              : Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).disabledColor),
          ),
          Divider(
            color: enable
              ? Theme.of(context).textTheme.bodyLarge?.color
              : Theme.of(context).disabledColor,
          ),
        ],
      ),
    );
  }
}
