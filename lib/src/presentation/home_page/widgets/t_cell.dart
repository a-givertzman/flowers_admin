
import 'package:flowers_admin/src/core/log/log.dart';
import 'package:flutter/material.dart';

///
///
class TCell extends StatefulWidget {
  final String _value;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
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
    _editable = editable;

  @override
  // ignore: no_logic_in_create_state
  State<TCell> createState() => _TCellState(
    value: _value,
    style: _style,
    onComplete: _onComplete,
    editable: _editable,
  );
}
///
///
class _TCellState extends State<TCell> {
  final _log = Log("$_TCellState._");
  final String _value;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  final _editable;
  final _textPaddingV = 8.0;
  final _textPaddingH = 16.0;
  final _textAlign = TextAlign.left;
  bool _isEditing = false;
  late final TextEditingController _controller = TextEditingController();
  _TCellState({
    required String value,
    required TextStyle? style,
    required void Function(String value)? onComplete,
    required bool editable,
  }) :
    _value = value,
    _style = style,
    _onComplete = onComplete,
    _editable = editable;
  ///
  ///
  @override
  void initState() {
    _controller.text = _value;
    // _log.debug("initState | _controller.text: ${_controller.text}");
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
        ? TextField(
          controller: _controller,
          style: _style,
          textAlign: _textAlign,
           decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH - 10.0),
            border: const OutlineInputBorder(borderSide: BorderSide(width: 0.1)),
            // border: const OutlineInputBorder(),
            isDense: true,
            // labelText: 'Password',
          ),
          onTapOutside: (_) {
            _applyNewValue(_controller.text);
          },
          onEditingComplete: () {
            _applyNewValue(_controller.text);
          },
        )
        : Padding(
          padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
          child: Text(
            _controller.text,
            style: _style,
            textAlign: _textAlign,
          ),
        ),
    );
  }
  ///
  ///
  _applyNewValue(String value) {
    setState(() {
      _isEditing = false;
    });
    final onComplete = _onComplete;
    if (onComplete != null) onComplete(value);
  }
}
