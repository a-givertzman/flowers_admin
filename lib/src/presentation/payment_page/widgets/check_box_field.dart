import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';

///
/// [TableWidget] CheckBox
class CheckBoxField<T extends SchemaEntryAbstract> extends StatefulWidget {
  final SchemaEntryAbstract _entry;
  final void Function(T entry)? _onChanged;
  ///
  /// [TableWidget] CheckBox
  const CheckBoxField({
    super.key,
    required SchemaEntryAbstract entry,
    required void Function(T entry)? onChanged
  }):
    _entry = entry,
    _onChanged = onChanged;
  //
  //
  @override
  State<CheckBoxField> createState() => _CheckBoxFieldState();
}
//
//
class _CheckBoxFieldState extends State<CheckBoxField> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget._entry.value('pay').value,
      onChanged: (value) {
        setState(() {
          widget._entry.update('pay', value);
        });
        final onChanged = widget._onChanged;
        if (onChanged != null) {
          onChanged(widget._entry);
        }
      },
    );
  }
}
