
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
///
/// Drop-downd editable list used in the form
class EditListWidget extends StatefulWidget {
  final String? _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  // final void Function(String value)? _onSelectionChange;
  final String? _labelText;
  final bool _editable;
  ///
  ///
  EditListWidget({
    super.key,
    required String? id,
    EditListEntry? relation,
    TextStyle? style,
    void Function(String value)? onComplete,
    // void Function(String value)? onSelectionChange,
    String? labelText,
    bool editable = true,
  }) :
    _id = id,
    _relation = relation ?? EditListEntry.empty(),
    _style = style,
    _onComplete = onComplete,
    // _onSelectionChange = onSelectionChange,
    _labelText = labelText,
    _editable = editable;

  @override
  // ignore: no_logic_in_create_state
  State<EditListWidget> createState() => _EditListWidgetState(
    id: _id,
    relation: _relation,
    style: _style,
    onComplete: _onComplete,
    labelText: _labelText,
    editable: _editable,
  );
}
//
//
class _EditListWidgetState extends State<EditListWidget> {
  // final _log = Log("$_EditListState._");
  String _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final bool _editable;
  // final _textPaddingH = 0.0;
  final _textPaddingV = 8.0;
  // final _textAlign = TextAlign.left;
  final String? _labelText;
  //
  //
  _EditListWidgetState({
    required String? id,
    required EditListEntry relation,
    required TextStyle? style,
    required void Function(String value)? onComplete,
    required String? labelText,
    required bool editable,
  }) :
    _id = id ?? '',
    _relation = relation,
    _style = style,
    _onComplete = onComplete,
    _labelText = labelText,
    _editable = editable;
  //
  //
  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyLarge;
    final style = _editable
      ? _style ?? defaultStyle
      : (_style ?? defaultStyle)?.copyWith(color: (_style ?? defaultStyle)?.color?.withValues(alpha: 0.5));
    return AbsorbPointer(
      absorbing: !_editable,
      child: DropdownButtonFormField(
        value: _relation.value(_id).isNotEmpty ? _id : '',
        items: {...{'': '---'}, ..._relation.entry}.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(
              entry.value,
              style: _style,
            ),
          );
        }).toList(),
        onChanged: (id) {
          final onComplete = _onComplete;
          if (onComplete != null) onComplete('$id');
        },
        style: style,
        iconSize: 0.0,
        isDense: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV),
          labelText: _labelText,
          filled: true,
          fillColor: Colors.transparent,
          hoverColor: Theme.of(context).hoverColor,
        ),
      ),
    );
  }
}
