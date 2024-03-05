
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
    bool editable = true,
  }) :
    _id = id,
    _relation = relation ?? EditListEntry.empty(),
    _style = style,
    _onComplete = onComplete,
    // _onSelectionChange = onSelectionChange,
    _editable = editable;

  @override
  // ignore: no_logic_in_create_state
  State<EditList> createState() => _EditListState(
    id: _id,
    relation: _relation,
    style: _style,
    onComplete: _onComplete,
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
  final _textPaddingH = 16.0;
  final _textPaddingV = 8.0;
  final _textAlign = TextAlign.left;
  bool _isEditing = false;
  _EditListState({
    required String id,
    required EditListEntry relation,
    required TextStyle? style,
    required void Function(String value)? onComplete,
    required bool editable,
  }) :
    _id = id,
    _relation = relation,
    _style = style,
    _onComplete = onComplete,
    _editable = editable;
  ///
  ///
  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return DropdownButton(
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
            padding: EdgeInsets.symmetric(vertical: _textPaddingV - 8.0, horizontal: _textPaddingH),
          );
    }
    return GestureDetector(
      onTap: switchToEditing,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
          child: Text(
            _relation.value(_id),
            style: _style,
            textAlign: _textAlign,
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
      _id = id;
    });
    final onComplete = _onComplete;
    if (onComplete != null) onComplete('$id');
  }
}
