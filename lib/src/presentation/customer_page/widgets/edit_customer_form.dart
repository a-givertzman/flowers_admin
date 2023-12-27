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
  bool _isChanged = false;
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
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'email'.inRu(),
                      value: '${_entry.value('email').value}',
                      onComplete: (value) {
                        _entry.update('email', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'phone'.inRu(),
                      value: '${_entry.value('phone').value}',
                      onComplete: (value) {
                        _entry.update('phone', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'name'.inRu(),
                      value: '${_entry.value('name').value}',
                      onComplete: (value) {
                        _entry.update('name', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'location'.inRu(),
                      value: '${_entry.value('location').value}',
                      onComplete: (value) {
                        _entry.update('location', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'login'.inRu(),
                      value: '${_entry.value('login').value}',
                      onComplete: (value) {
                        _entry.update('login', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'pass'.inRu(),
                      value: '${_entry.value('pass').value}',
                      onComplete: (value) {
                        _entry.update('pass', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'account'.inRu(),
                      value: '${_entry.value('account').value}',
                      onComplete: (value) {
                        _entry.update('account', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    Checkbox(
                      semanticLabel: 'Blocked'.inRu(),
                      value: _entry.value('blocked').value ?? false, 
                      onChanged: (value) {
                        _entry.update('blocked', value ?? false);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'last_act'.inRu(),
                      value: '${_entry.value('last_act').value}',
                      onComplete: (value) {
                        _entry.update('last_act', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'created'.inRu(),
                      value: '${_entry.value('created').value}',
                      onComplete: (value) {
                        _entry.update('created', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'updated'.inRu(),
                      value: '${_entry.value('updated').value}',
                      onComplete: (value) {
                        _entry.update('updated', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
                      },
                    ),
                    TextEditWidget(
                      labelText: 'deleted'.inRu(),
                      value: '${_entry.value('deleted').value}',
                      onComplete: (value) {
                        _entry.update('deleted', value);
                        setState(() {
                          _isChanged = _entry.isChanged;
                        });
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
                    onPressed: _isChanged 
                      ? () {
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
  final String _value;
  bool _isChanged = false;
  ///
  ///
  _TextEditWidgetState({
    required String value,
    Function(String)? onComplete,
    String? labelText,
  }):
    _value = value,
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
        style: _isChanged 
          ? Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.error)
          : null,
        // textAlign: _textAlign,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH - 10.0),
          // border: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: _isChanged ? Colors.red : Colors.black)),
          // border: const OutlineInputBorder(),
          isDense: true,
          labelText: _labelText,
        ),
        onChanged: (value) {
          setState(() {
            _isChanged = value != _value;
          });
        },
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
    if (value != _value) {
      final onComplete = _onComplete;
      if (onComplete != null) onComplete(value);
    }
  }
}