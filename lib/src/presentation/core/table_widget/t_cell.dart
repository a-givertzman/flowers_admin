
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';

///
///
class TCell<T extends SchemaEntryAbstract> extends StatefulWidget {
  final String value;
  final TextStyle? style;
  final void Function(String value)? onComplete;
  final Widget Function(BuildContext, T)? _builder;
  final T? entry;
  final bool editable;
  final int flex;
  ///
  ///
  const TCell({
    super.key,
    this.value = '',
    this.style,
    this.onComplete,
    this.editable = true,
    this.flex = 1,
  }) :
    _builder = null,
    entry = null;
  ///
  ///
  const TCell.builder({
    super.key,
    this.value = '',
    this.style,
    this.onComplete,
    required Widget Function(BuildContext, T)? builder,
    required T this.entry,
    this.editable = true,
    this.flex = 1,
  }) :
    _builder = builder;
  //
  //
  @override
  State<TCell<T>> createState() => _TCellState();
}
//
//
class _TCellState<T extends SchemaEntryAbstract> extends State<TCell<T>> {
  // late final _log = Log;
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
    // _log = Log("$_TCellState._");
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
    final TextStyle? style = widget.style;
    final flex = widget.flex;
    final bool editable = widget.editable;
    final builder = widget._builder;
    final entry = widget.entry;
    if (builder != null && entry != null) {
      return Expanded(
        flex: flex,
        child: builder(context, entry),
      );
    }
    return Expanded(
      flex: flex,
      child: _isEditing
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
                  boxShadow: _onEnter ? [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 4)]  : null,
                ),
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
