
import 'package:flowers_admin/src/core/log/log.dart';
import 'package:flutter/material.dart';

///
///
class TCell extends StatefulWidget {
  final String _value;
  final TextStyle? _stile;
  final void Function(String value)? _onComplete;
  ///
  ///
  const TCell({
    super.key,
    String value = '',
    TextStyle? style,
    void Function(String value)? onComplete,
  }) :
    _value = value,
    _stile = style,
    _onComplete = onComplete;

  @override
  State<TCell> createState() => _TCellState();
}

class _TCellState extends State<TCell> {
  final _log = Log("$_TCellState._");
  final _textPaddingV = 8.0;
  final _textPaddingH = 16.0;
  final _textAlign = TextAlign.left;
  bool _isEditing = false;
  late final TextEditingController _controller = TextEditingController();
  ///
  ///
  @override
  void initState() {
    _controller.text = widget._value;
    // _log.debug("initState | _controller.text: ${_controller.text}");
    super.initState();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: _isEditing
        ? TextField(
          controller: _controller,
          style: widget._stile,
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
            style: widget._stile,
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
    final onComplete = widget._onComplete;
    if (onComplete != null) onComplete(value);
  }
}
