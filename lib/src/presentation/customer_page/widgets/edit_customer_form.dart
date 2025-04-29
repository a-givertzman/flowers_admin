import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/form_widget/edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class EditCustomerForm extends StatefulWidget {
  final AppUser user;
  final List<Field<EntryCustomer>> fields;
  final EntryCustomer? entry;
  ///
  ///
  const EditCustomerForm({
    super.key,
    required this.user,
    required this.fields,
    this.entry,
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditCustomerForm> createState() => _EditCustomerFormState();
}
//
//
class _EditCustomerFormState extends State<EditCustomerForm> {
  late final Log _log;
  late EntryCustomer _entry;
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _entry = widget.entry ?? EntryCustomer.empty();
    super.initState();
  }
  ///
  ///
  Field<EntryCustomer> _field(String key, List<Field<EntryCustomer>> fields) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryCustomer>(key: key);
    });
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final fields = widget.fields;
    final roleEntries = AppUserRole.values.asMap().map((i, role) {
      return MapEntry(role.str, EntryCustomer(map: {'id': FieldValue(role.str), 'role': FieldValue(role.str)}));
    },);
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
                    labelText: _field('picture', fields).title.inRu,
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
                        id: '${_entry.value('role').value}',
                        relation: EditListEntry(field: 'role', entries: roleEntries.values.toList()),
                        editable: _field('role', fields).isEditable,
                        // style: textStyle,
                        labelText: _field('role', fields).title.inRu,
                        onComplete: (id) {
                          final role = roleEntries[id]?.value('role').value;
                          _log.debug('build.onComplete | role: $role');
                          if (role != null) {
                            _entry.update('role', role);
                            setState(() {return;});
                          }
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('email', fields).title.inRu,
                        value: '${_entry.value('email').value}',
                        editable: _field('email', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('email', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('phone', fields).title.inRu,
                        value: '${_entry.value('phone').value}',
                        editable: _field('phone', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('phone', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('name', fields).title.inRu,
                        value: '${_entry.value('name').value}',
                        editable: _field('name', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('name', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('location', fields).title.inRu,
                        value: '${_entry.value('location').value}',
                        editable: _field('location', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('location', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('login', fields).title.inRu,
                        value: '${_entry.value('login').value}',
                        editable: _field('login', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('login', value);
                          _log.debug('.TextEditWidget.onComplete | enrty: $_entry');
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('pass', fields).title.inRu,
                        value: '${_entry.value('pass').value}',
                        editable: _field('pass', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('pass', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('account', fields).title.inRu,
                        value: '${_entry.value('account').value}',
                        editable: _field('account', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('account', value);
                          setState(() {return;});
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(_field('Blocked', fields).title.inRu),
                        value: _entry.value('blocked').value ?? false, 
                        enabled: _field('blocked', fields).isEditable,
                        onChanged: (value) {
                          _entry.update('blocked', value ?? false);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('last_act', fields).title.inRu,
                        value: '${_entry.value('last_act').value}',
                        editable: _field('last_act', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('last_act', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('created', fields).title.inRu,
                        value: '${_entry.value('created').value}',
                        editable: _field('created', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('created', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('updated', fields).title.inRu,
                        value: '${_entry.value('updated').value}',
                        editable: _field('updated', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('updated', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: _field('deleted', fields).title.inRu,
                        value: '${_entry.value('deleted').value}',
                        editable: _field('deleted', fields).isEditable,
                        onComplete: (value) {
                          _entry.update('deleted', value);
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
                  Navigator.pop(context, const Err<EntryCustomer, void>(null));
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: _entry.isChanged 
                  ? () {
                    _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    _log.debug('.TextButton.Yes | enrty: $_entry');
                    Navigator.pop(context, Ok<EntryCustomer, void>(_entry));
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
