
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
///
///
class EditList extends StatefulWidget {
  final String _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  // final void Function(String value)? _onSelectionChange;
  final String? _labelText;
  final bool _editable;
  ///
  ///
  EditList({
    super.key,
    required String id,
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
  State<EditList> createState() => _EditListState(
    id: _id,
    relation: _relation,
    style: _style,
    onComplete: _onComplete,
    labelText: _labelText,
    editable: _editable,
  );
}
///
///
class _EditListState extends State<EditList> {
  // final _log = Log("$_EditListState._");
  String _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final bool _editable;
  final _textPaddingH = 0.0;
  final _textPaddingV = 8.0;
  final _textAlign = TextAlign.left;
  final String? _labelText;
  bool _isEditing = false;
  bool _isChanged = false;
  //
  //
  _EditListState({
    required String id,
    required EditListEntry relation,
    required TextStyle? style,
    required void Function(String value)? onComplete,
    required String? labelText,
    required bool editable,
  }) :
    _id = id,
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
      : (_style ?? defaultStyle)?.copyWith(color: (_style ?? defaultStyle)?.color?.withOpacity(0.5));
    if (_isEditing) {
      return DropdownButtonFormField(
            value: _id,
            items: _relation.values.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: _style,
                ),
              );
            }).toList(),
            onChanged: (value) {
              _applyNewValue(value);
            },
            style: _style,
            iconSize: 0.0,
            isDense: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV),
              labelText: _labelText,
            ),
          );
    }
    return GestureDetector(
      onTap: switchToEditing,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isEditing && _labelText != null)
                Text(
                  '$_labelText',
                  style: Theme.of(context).inputDecorationTheme.labelStyle ?? Theme.of(context).textTheme.bodySmall,
                ),
              Text(
                _relation.value(_id),
                style: _isChanged 
                  ? style?.copyWith(color: Theme.of(context).colorScheme.error)
                  : style,
                textAlign: _textAlign,
              ),
            ],
          ),
        ),
    );
  }
  ///
  ///
  void switchToEditing() {
    if (_editable) {
      setState(() {
        _isEditing = true;
      });
    }
  }
  ///
  ///
  _applyNewValue(id) {
    setState(() {
      _isEditing = false;
      if (id != _id) {
        _isChanged = true;
        _id = id;
      }
    });
    final onComplete = _onComplete;
    if (onComplete != null) onComplete('$id');
  }
}
