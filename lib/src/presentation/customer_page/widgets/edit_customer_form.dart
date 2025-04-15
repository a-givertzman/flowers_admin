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
  final _log = Log("$_EditCustomerFormState");
  //
  //
  ///
  ///
  Field<EntryCustomer> _field(String key, List<Field<EntryCustomer>> fields) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryCustomer>(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final fields = widget.fields;
    final entry = widget.entry ?? EntryCustomer.empty();
    final title = entry.isEmpty ? InRu('Create customer') : InRu('Edit customer');
    final editableRole = [AppUserRole.admin].contains(user.role);
    final editableLogin = [AppUserRole.admin].contains(user.role);
    final editablePass = [AppUserRole.admin].contains(user.role);
    final editableAccount = [AppUserRole.admin].contains(user.role);
    final roleEntries = AppUserRole.values.asMap().map((i, role) {
      return MapEntry(role.str, EntryCustomer(map: {'id': FieldValue(role.str), 'role': FieldValue(role.str)}));
    },);
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$title ${entry.value('name').str}', style: Theme.of(context).textTheme.titleLarge,),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const LoadImageWidget(src: 'https://drive.google.com/uc?export=view&id=19gswvDI6xJod7kWm4cgRpqYbb2duiKB4',),
                    EditListWidget(
                      id: '${entry.value('role').value}',
                      relation: EditListEntry(field: 'role', entries: roleEntries.values.toList()),
                      editable: editableRole,
                      // style: textStyle,
                      labelText: _field('role', fields).title.inRu,
                      onComplete: (id) {
                        final role = roleEntries[id]?.value('role').value;
                        _log.debug('build.onComplete | role: $role');
                        if (role != null) {
                          entry.update('role', role);
                          setState(() {return;});
                        }
                      },
                    ),

                    // TextEditWidget(
                    //   editable: editableRole,
                    //   labelText: 'role'.inRu,
                    //   value: '${entry.value('role').value}',
                    //   onComplete: (value) {
                    //     entry.update('role', value);
                    //     setState(() {return;});
                    //   },
                    // ),
                    TextEditWidget(
                      labelText: _field('email', fields).title.inRu,
                      value: '${entry.value('email').value}',
                      onComplete: (value) {
                        entry.update('email', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('phone', fields).title.inRu,
                      value: '${entry.value('phone').value}',
                      onComplete: (value) {
                        entry.update('phone', value);
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
                      labelText: _field('location', fields).title.inRu,
                      value: '${entry.value('location').value}',
                      onComplete: (value) {
                        entry.update('location', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      editable: editableLogin,
                      labelText: _field('login', fields).title.inRu,
                      value: '${entry.value('login').value}',
                      onComplete: (value) {
                        entry.update('login', value);
                        _log.debug('.TextEditWidget.onComplete | enrty: $entry');
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      editable: editablePass,
                      labelText: _field('pass', fields).title.inRu,
                      value: '${entry.value('pass').value}',
                      onComplete: (value) {
                        entry.update('pass', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      editable: editableAccount,
                      labelText: _field('account', fields).title.inRu,
                      value: '${entry.value('account').value}',
                      onComplete: (value) {
                        entry.update('account', value);
                        setState(() {return;});
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_field('Blocked', fields).title.inRu),
                      value: entry.value('blocked').value ?? false, 
                      onChanged: (value) {
                        entry.update('blocked', value ?? false);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('last_act', fields).title.inRu,
                      value: '${entry.value('last_act').value}',
                      onComplete: (value) {
                        entry.update('last_act', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('created', fields).title.inRu,
                      value: '${entry.value('created').value}',
                      onComplete: (value) {
                        entry.update('created', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('updated', fields).title.inRu,
                      value: '${entry.value('updated').value}',
                      onComplete: (value) {
                        entry.update('updated', value);
                        setState(() {return;});
                      },
                    ),
                    TextEditWidget(
                      labelText: _field('deleted', fields).title.inRu,
                      editable: [AppUserRole.admin].contains(user.role),
                      value: '${entry.value('deleted').value}',
                      onComplete: (value) {
                        entry.update('deleted', value);
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
                      Navigator.pop(context, const Err<EntryCustomer, void>(null));
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: entry.isChanged 
                      ? () {
                        _log.debug('.TextButton.Yes | _isChanged: ${entry.isChanged}');
                        _log.debug('.TextButton.Yes | enrty: $entry');
                        Navigator.pop(context, Ok<EntryCustomer, void>(entry));
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
