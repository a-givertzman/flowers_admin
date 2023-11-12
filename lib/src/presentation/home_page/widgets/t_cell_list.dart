
import 'package:flowers_admin/src/core/log/log.dart';
import 'package:flowers_admin/src/infrostructure/schames/scheme_entry.dart';
import 'package:flutter/material.dart';

///
///
class TCellList extends StatefulWidget {
  final dynamic _id;
  final List<SchemeEntry> _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final bool _editable;
  ///
  ///
  const TCellList({
    super.key,
    required dynamic id,
    List<SchemeEntry> relation = const [],
    TextStyle? style,
    void Function(String value)? onComplete,
    bool editable = true,
  }) :
    _id = id,
    _relation = relation,
    _style = style,
    _onComplete = onComplete,
    _editable = editable;

  @override
  // ignore: no_logic_in_create_state
  State<TCellList> createState() => _TCellListState(
    id: _id,
    relation: _relation,
    style: _style,
    onComplete: _onComplete,
    editable: _editable,
  );
}
///
///
class _TCellListState extends State<TCellList> {
  final _log = Log("$_TCellListState._");
  dynamic _id;
  String _value = '';
  final List<SchemeEntry> _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final bool _editable;
  final _textPaddingH = 16.0;
  final _textPaddingV = 8.0;
  final _textAlign = TextAlign.left;
  bool _isEditing = false;
  _TCellListState({
    required dynamic id,
    required List<SchemeEntry> relation,
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
  void initState() {
    // _controller.text = _value;
    // _log.debug("initState | _controller.text: ${_controller.text}");
    _log.debug("._build | id '$_id'");
    for (final entry in _relation) {
      if (entry.value('id').value == _id) {
        _value = entry.value('name').value.toString();
        break;
      }
    }
    _log.debug("._build | value '$_value'");
    super.initState();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_editable) {
          setState(() {
            _isEditing = true;
          });
        }
      },
      child: _isEditing
        ? DropdownButton(
            value: _id,
            items: _relation.map((entry) {
              final id = entry.value('id').value;
              final value = entry.value('name').value;
              _log.debug("._build | item '$value'");
              return DropdownMenuItem(
                value: id,
                child: Text(
                  '$value',
                  style: _style,
                ),
              );
            }).toList(),
            onChanged: (value) {
              _applyNewValue('$value');
            },
            style: _style,
            iconSize: 0.0,
            isDense: true,
            padding: EdgeInsets.symmetric(vertical: _textPaddingV - 8.0, horizontal: _textPaddingH),
          )
        : Padding(
          padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
          child: Text(
            _value,
            style: _style,
            textAlign: _textAlign,
          ),
        ),
    );
  }
  ///
  ///
  _applyNewValue(String id) {
    setState(() {
      _isEditing = false;
      _id = id;
      _value = _relation.firstWhere((entry) => '${entry.value('id').value}' == _id).value('name').value.toString();
    });
    final onComplete = _onComplete;
    if (onComplete != null) onComplete(id);
  }
}
