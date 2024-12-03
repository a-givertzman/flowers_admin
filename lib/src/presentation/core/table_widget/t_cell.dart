
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';

///
///
class TCell extends StatefulWidget {
  final String _value;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final Widget Function(BuildContext, SchemaEntryAbstract)? _builder;
  final SchemaEntryAbstract? _entry;
  final bool _editable;
  ///
  ///
  const TCell({
    super.key,
    String value = '',
    TextStyle? style,
    void Function(String value)? onComplete,
    bool editable = true,
  }) :
    _value = value,
    _style = style,
    _onComplete = onComplete,
    _builder = null,
    _entry = null,
    _editable = editable;
  ///
  ///
  const TCell.builder({
    super.key,
    String value = '',
    TextStyle? style,
    void Function(String value)? onComplete,
    required Widget Function(BuildContext, SchemaEntryAbstract)? builder,
    required SchemaEntryAbstract entry,
    bool editable = true,
  }) :
    _value = value,
    _style = style,
    _onComplete = onComplete,
    _builder = builder,
    _entry = entry,
    _editable = editable;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<TCell> createState() => _TCellState(
    value: _value,
    style: _style,
    onComplete: _onComplete,
    editable: _editable,
  );
}
//
//
class _TCellState extends State<TCell> {
  // final _log = Log("$_TCellState._");
  final TextEditingController _controller;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final bool _editable;
  final _textPaddingV = 8.0;
  final _textPaddingH = 16.0;
  final _textAlign = TextAlign.left;
  final String _value;
  bool _isEditing = false;
  bool _isChanged = false;
  bool _onEnter = false;
  _TCellState({
    required String value,
    required TextStyle? style,
    required void Function(String value)? onComplete,
    required bool editable,
  }) :
    _value = value,
    _controller = TextEditingController.fromValue(TextEditingValue(text: value)),
    _style = style,
    _onComplete = onComplete,
    _editable = editable;
  //
  //
  @override
  Widget build(BuildContext context) {
    final builder = widget._builder;
    final entry = widget._entry;
    if (builder != null && entry != null) {
      return Expanded(child: builder(context, entry));
    }
    return Expanded(
      child: _isEditing
        ? TextField(
          controller: _controller,
          style: _style,
          textAlign: _textAlign,
           decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH - 10.0),
            // border: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: _isChanged ? Colors.red : Colors.black)),
            // border: const OutlineInputBorder(),
            isDense: true,
            // labelText: 'Password',
          ),
          onChanged: (value) {
            setState(() {
              _isChanged = value != _value;
            });
          },
          onTapOutside: (_) {
            _applyNewValue(_controller.text);
          },
          onEditingComplete: () {
            _applyNewValue(_controller.text);
          },
        )
        : Padding(
          padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _onEnter = true;
              });
            },
            onExit: (_) {
              setState(() {
                _onEnter = false;
              });
            },
            child: GestureDetector(
              // behavior: HitTestBehavior.translucent,
              onTap: () {
                if (_editable) {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  // border: _onEnter ? Border.all() : Border.all(color: Colors.transparent),
                  boxShadow: _onEnter ? [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4)]  : null,
                ),
                child: Text(
                  _controller.text,
                  style: _style?.copyWith(color: _isChanged ? Colors.red : null),
                  textAlign: _textAlign,
                ),
              ),
            ),
          ),
        ),
    );
  }
  ///
  ///
  _applyNewValue(String value) {
    setState(() {
      _isEditing = false;
      _onEnter = false;
    });
    if (value != _value) {
      final onComplete = _onComplete;
      if (onComplete != null) onComplete(value);
    }
  }
}
