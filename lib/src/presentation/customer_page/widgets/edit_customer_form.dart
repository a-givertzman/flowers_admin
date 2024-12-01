import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class EditCustomerForm extends StatefulWidget {
  final AppUser _user;
  final EntryCustomer? _entry;
  ///
  ///
  const EditCustomerForm({
    super.key,
    required AppUser user,
    EntryCustomer? entry,
  }):
    _user = user,
    _entry = entry;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditCustomerForm> createState() => _EditCustomerFormState(
    user: _user,
    entry: _entry ?? EntryCustomer.empty(),
  );
}
///
///
class _EditCustomerFormState extends State<EditCustomerForm> {
  final _log = Log("$_EditCustomerFormState._");
  final AppUser _user;
  final EntryCustomer _entry;
  ///
  ///
  _EditCustomerFormState({
    required AppUser user,
    required EntryCustomer entry,
  }):
    _user = user,
    _entry = entry;
  //
  //
  @override
  Widget build(BuildContext context) {
    final editableRole = [AppUserRole.admin].contains(_user.role);
    final editableLogin = [AppUserRole.admin].contains(_user.role);
    final editablePass = [AppUserRole.admin].contains(_user.role);
    final editableAccount = [AppUserRole.admin].contains(_user.role);
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${InRu('Edit customer')} ${_entry.value('name')}', style: Theme.of(context).textTheme.titleLarge,),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const LoadImageWidget(src: 'https://drive.google.com/uc?export=view&id=19gswvDI6xJod7kWm4cgRpqYbb2duiKB4',),
                      TextEditWidget(
                        editable: editableRole,
                        labelText: 'role'.inRu,
                        value: '${_entry.value('role').value}',
                        onComplete: (value) {
                          _entry.update('role', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'email'.inRu,
                        value: '${_entry.value('email').value}',
                        onComplete: (value) {
                          _entry.update('email', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'phone'.inRu,
                        value: '${_entry.value('phone').value}',
                        onComplete: (value) {
                          _entry.update('phone', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'name'.inRu,
                        value: '${_entry.value('name').value}',
                        onComplete: (value) {
                          _entry.update('name', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'location'.inRu,
                        value: '${_entry.value('location').value}',
                        onComplete: (value) {
                          _entry.update('location', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        editable: editableLogin,
                        labelText: 'login'.inRu,
                        value: '${_entry.value('login').value}',
                        onComplete: (value) {
                          _entry.update('login', value);
                          _log.debug('.TextEditWidget.onComplete | enrty: $_entry');
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        editable: editablePass,
                        labelText: 'pass'.inRu,
                        value: '${_entry.value('pass').value}',
                        onComplete: (value) {
                          _entry.update('pass', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        editable: editableAccount,
                        labelText: 'account'.inRu,
                        value: '${_entry.value('account').value}',
                        onComplete: (value) {
                          _entry.update('account', value);
                          setState(() {return;});
                        },
                      ),
                      Checkbox(
                        semanticLabel: 'Blocked'.inRu,
                        value: _entry.value('blocked').value ?? false, 
                        onChanged: (value) {
                          _entry.update('blocked', value ?? false);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'last_act'.inRu,
                        value: '${_entry.value('last_act').value}',
                        onComplete: (value) {
                          _entry.update('last_act', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'created'.inRu,
                        value: '${_entry.value('created').value}',
                        onComplete: (value) {
                          _entry.update('created', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'updated'.inRu,
                        value: '${_entry.value('updated').value}',
                        onComplete: (value) {
                          _entry.update('updated', value);
                          setState(() {return;});
                        },
                      ),
                      TextEditWidget(
                        labelText: 'deleted'.inRu,
                        value: '${_entry.value('deleted').value}',
                        onComplete: (value) {
                          _entry.update('deleted', value);
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
                      onPressed: _entry.isChanged 
                        ? () {
                          _log.debug('.TextButton.Yes | _isChanged: ${_entry.isChanged}');
                          _log.debug('.TextButton.Yes | enrty: $_entry');
                          Navigator.pop(context, Ok<EntryCustomer, void>(_entry));
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
      ),
    );
  }
}
