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
  final TextEditingController _controller;
  final _apiAddress = ApiAddress.localhost(port: 8080);
  final _paddingH = 8.0;
  final _paddingV = 8.0;
  ///
  ///
  _CustomerBodyState({
    required EntryCustomer? entry,
  }):
    _entry = entry,
    _controller = TextEditingController.fromValue(TextEditingValue(text: entry?.value('name').toString() ?? ''));
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
            TextField(
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
              onChanged: (value) {
                _entry?.update('key', value);
              },
              onTapOutside: (_) {
              },
              onEditingComplete: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
