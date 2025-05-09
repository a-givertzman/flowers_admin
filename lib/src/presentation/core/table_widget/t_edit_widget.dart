import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';

///
/// Edit field for [TableWidget]
class TEditWidget<T extends SchemaEntryAbstract> extends StatefulWidget {
  final String value;
  final String hint;
  final TextStyle? style;
  final void Function(String value)? onComplete;
  final T? entry;
  final bool editable;
  ///
  ///
  const TEditWidget({
    super.key,
    this.value = '',
    this.hint = '',
    this.style,
    this.onComplete,
    this.editable = true,
  }) :
    entry = null;
  //
  //
  @override
  State<TEditWidget<T>> createState() => _TEditWidgetState();
}
//
//
class _TEditWidgetState<T extends SchemaEntryAbstract> extends State<TEditWidget<T>> {
  // ignore: unused_field
  late final Log _log;
  late final TextEditingController _controller;
  final _textPaddingV = 8.0;
  final _textPaddingH = 16.0;
  final _textAlign = TextAlign.left;
  bool _isEditing = false;
  bool _isChanged = false;
  bool _onEnter = false;
  //
  //
  @override
  void initState() {
    _log = Log('$runtimeType');
    _controller = TextEditingController.fromValue(TextEditingValue(text: widget.value));
    super.initState();
  }
  //
  //
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final isHeader = widget.entry == null;
    final TextStyle? style = widget.style;
    final bool editable = widget.editable;
    return _isEditing
      ? TapRegion(
        onTapOutside: (PointerDownEvent _) {
          if (_isEditing) {
            _applyNewValue(_controller.text);
            setState(() {
              _isEditing = false;
            });
          }
        },
        child: TextField(
          controller: _controller,
          style: style,
          textAlign: _textAlign,
            decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH - 10.0),
            // border: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: _isChanged ? Colors.red : Colors.black)),
            // border: const OutlineInputBorder(),
            isDense: true,
            // labelText: 'Password',
          ),
          onChanged: (value) {
            _isChanged = value != widget.value;
          },
          onEditingComplete: () {
            _applyNewValue(_controller.text);
          },
        ),
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
              if (editable) {
                setState(() {
                  _isEditing = true;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                // border: _onEnter ? Border.all() : Border.all(color: Colors.transparent),
                boxShadow: (_onEnter && !isHeader)
                  ? [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 4)] 
                  : null,
              ),
              child: widget.hint.isEmpty
                ? Text(
                  _controller.text,
                  style: style?.copyWith(color: _isChanged ? Colors.blue : null),
                  textAlign: _textAlign,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )
                : Tooltip(
                  message: widget.hint,
                  child: Text(
                    _controller.text,
                    style: style?.copyWith(color: _isChanged ? Colors.blue : null),
                    textAlign: _textAlign,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
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
    if (value != widget.value) {
      final onComplete = widget.onComplete;
      if (onComplete != null) onComplete(value);
    }
  }
}
