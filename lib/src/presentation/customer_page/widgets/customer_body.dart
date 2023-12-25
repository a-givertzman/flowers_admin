import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
import 'package:flutter/material.dart';

///
///
class CustomerBody extends StatefulWidget {
  final EntryCustomer? _entry;
  ///
  ///
  const CustomerBody({
    super.key,
    EntryCustomer? entry,
  }):
    _entry = entry;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<CustomerBody> createState() => _CustomerBodyState(
    entry: _entry,
  );
}
///
///
class _CustomerBodyState extends State<CustomerBody> {
  // final _log = Log("$_CustomerBodyState._");
  final EntryCustomer? _entry;
  final _apiAddress = ApiAddress.localhost(port: 8080);
  final _paddingH = 8.0;
  final _paddingV = 8.0;
  ///
  ///
  _CustomerBodyState({
    required EntryCustomer? entry,
  }):
    _entry = entry;
  //
  //
  @override
  Widget build(BuildContext context) {
    final tabHeadesStyle = Theme.of(context).textTheme.headlineSmall;
    return MaterialApp(
      title: 'Customer',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Customer page ${_entry?.value('name')}'),
        ),
        body: Column(
          children: [
            TextEditWidget(
              value: _entry?.value('name').str,
              onComplete: (value) {
                _entry?.update('name', value);
              },
            ),
          ],
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
  ///
  ///
  const TextEditWidget({
    super.key,
    String? value = '',
    Function(String)? onComplete,
  }):
    _value = value ?? '',
    _onComplete = onComplete;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<TextEditWidget> createState() => _TextEditWidgetState(
    value: _value,
    onComplete: _onComplete,
  );
}
///
///
class _TextEditWidgetState extends State<TextEditWidget> {
  final Function(String)? _onComplete;
  final TextEditingController _controller;
  ///
  ///
  _TextEditWidgetState({
    required String value,
    Function(String)? onComplete,
  }):
    _controller = TextEditingController.fromValue(TextEditingValue(text: value)),
    _onComplete = onComplete;
  //
  //
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      // style: _style,
      // textAlign: _textAlign,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH - 10.0),
        border: const OutlineInputBorder(borderSide: BorderSide(width: 0.1)),
        // border: const OutlineInputBorder(),
        isDense: true,
        // labelText: 'Password',
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
    );
  }
  ///
  ///
  _onEditingComplete(String value) {
    final onComplete = _onComplete;
    if (onComplete != null) onComplete(value);
  }
}