import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
///
class EditCustomerForm extends StatefulWidget {
  final EntryCustomer? _entry;
  ///
  ///
  const EditCustomerForm({
    super.key,
    EntryCustomer? entry,
  }):
    _entry = entry;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditCustomerForm> createState() => _EditCustomerFormState(
    entry: _entry ?? EntryCustomer.empty(),
  );
}
///
///
class _EditCustomerFormState extends State<EditCustomerForm> {
  // final _log = Log("$_CustomerBodyState._");
  final EntryCustomer _entry;
  ///
  ///
  _EditCustomerFormState({
    required EntryCustomer entry,
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
                    TextEditWidget(
                      labelText: 'role'.inRu(),
                      value: '${_entry.value('role').value}',
                      onComplete: (value) {
                        _entry.update('role', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'email'.inRu(),
                      value: '${_entry.value('email').value}',
                      onComplete: (value) {
                        _entry.update('email', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'phone'.inRu(),
                      value: '${_entry.value('phone').value}',
                      onComplete: (value) {
                        _entry.update('phone', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'name'.inRu(),
                      value: '${_entry.value('name').value}',
                      onComplete: (value) {
                        _entry.update('name', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'location'.inRu(),
                      value: '${_entry.value('location').value}',
                      onComplete: (value) {
                        _entry.update('location', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'login'.inRu(),
                      value: '${_entry.value('login').value}',
                      onComplete: (value) {
                        _entry.update('login', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'pass'.inRu(),
                      value: '${_entry.value('pass').value}',
                      onComplete: (value) {
                        _entry.update('pass', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'account'.inRu(),
                      value: '${_entry.value('account').value}',
                      onComplete: (value) {
                        _entry.update('account', value);
                      },
                    ),
                    Checkbox(
                      semanticLabel: 'Blocked'.inRu(),
                      value: _entry.value('blocked').value ?? false, 
                      onChanged: (value) {
                        if (value != null) {
                          _entry.update('blocked', value);
                        }
                      },
                    ),
                    TextEditWidget(
                      labelText: 'last_act'.inRu(),
                      value: _entry.value('last_act').str,
                      onComplete: (value) {
                        _entry.update('last_act', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'created'.inRu(),
                      value: _entry.value('created').str,
                      onComplete: (value) {
                        _entry.update('created', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'updated'.inRu(),
                      value: _entry.value('updated').str,
                      onComplete: (value) {
                        _entry.update('updated', value);
                      },
                    ),
                    TextEditWidget(
                      labelText: 'deleted'.inRu(),
                      value: _entry.value('deleted').str,
                      onComplete: (value) {
                        _entry.update('deleted', value);
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed:  () {
                      Navigator.pop(context, const Err<EntryCustomer, void>(null));
                    },
                  ),
                  TextButton(
                    child: const Text("Yes"),
                    onPressed:  () {
                        Navigator.pop(context, Ok<EntryCustomer, void>(_entry));
                    },
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


///
///
class TextEditWidget extends StatefulWidget {
  final String _value;
  final Function(String)? _onComplete;
  final String? _labelText;
  ///
  ///
  const TextEditWidget({
    super.key,
    String? value = '',
    Function(String)? onComplete,
    String? labelText,
  }):
    _value = value ?? '',
    _onComplete = onComplete,
    _labelText = labelText;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<TextEditWidget> createState() => _TextEditWidgetState(
    value: _value,
    onComplete: _onComplete,
    labelText: _labelText,
  );
}
///
///
class _TextEditWidgetState extends State<TextEditWidget> {
  final Function(String)? _onComplete;
  final TextEditingController _controller;
  final String? _labelText;
  ///
  ///
  _TextEditWidgetState({
    required String value,
    Function(String)? onComplete,
    String? labelText,
  }):
    _controller = TextEditingController.fromValue(TextEditingValue(text: value)),
    _onComplete = onComplete,
    _labelText = labelText;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        // style: _style,
        // textAlign: _textAlign,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH - 10.0),
          border: const OutlineInputBorder(borderSide: BorderSide(width: 0.1)),
          // border: const OutlineInputBorder(),
          isDense: true,
          labelText: _labelText,
        ),
        // onChanged: (value) {
        //   _entry?.update('key', value);
        // },
        onTapOutside: (_) {
          _onEditingComplete(_controller.text);
        },
        onEditingComplete: () {
          _onEditingComplete(_controller.text);
        },
      ),
    );
  }
  ///
  ///
  _onEditingComplete(String value) {
    final onComplete = _onComplete;
    if (onComplete != null) onComplete(value);
  }
}