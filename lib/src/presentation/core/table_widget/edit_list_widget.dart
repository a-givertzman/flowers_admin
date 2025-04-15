
import 'package:flowers_admin/src/presentation/core/hover_builder.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
///
/// Drop-downd editable list used in the form
class TEditListWidget extends StatefulWidget {
  final String? _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  // final void Function(String value)? _onSelectionChange;
  final String? _labelText;
  final bool _editable;
  ///
  ///
  TEditListWidget({
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
  State<TEditListWidget> createState() => _TEditListWidgetState(
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
class _TEditListWidgetState extends State<TEditListWidget> {
  // final _log = Log("$_EditListState._");
  String _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final bool _editable;
  final _textPaddingH = 0.0;
  final _textPaddingV = 8.0;
  final _textAlign = TextAlign.justify;
  final String? _labelText;
  bool _isEditing = false;
  bool _isChanged = false;
  //
  //
  _TEditListWidgetState({
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
    if (_isEditing) {
      return DropdownButtonFormField(
            value: _relation.value(_id).isNotEmpty ? _id : '',
            items: {...{'': ''}, ..._relation.entry}.entries.map((entry) {
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
              filled: true,
              fillColor: Colors.transparent,
              hoverColor: Theme.of(context).hoverColor,

            ),
          );
    }
    return GestureDetector(
      onTap: switchToEditing,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isEditing && _labelText != null)
                Text(
                  '$_labelText',
                  style: Theme.of(context).inputDecorationTheme.labelStyle ?? Theme.of(context).textTheme.bodySmall,
                ),
              HoverBuilder(
                builder: (BuildContext context, bool isHovered) {
                  final rel = _relation.value(_id);
                  return Text(
                    _id.isNotEmpty ? (rel.isNotEmpty ? rel : '') : '',
                    // _id.isNotEmpty ? (rel.isNotEmpty ? rel : '${InRu('Not sampled')}') : '${InRu('Not sampled')}',
                    style: _isChanged 
                      ? style?.copyWith(
                        backgroundColor: isHovered ? Theme.of(context).hoverColor : null,
                        color: Theme.of(context).colorScheme.error,
                      )
                      : style,
                    textAlign: _textAlign,
                  );
                }
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
