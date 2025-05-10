import 'package:flutter/material.dart';

///
///
class TextEditWidget extends StatefulWidget {
  final String value;
  final Function(String)? onComplete;
  final String? labelText;
  final String? errorText;
  final bool editable;
  final TextStyle? style;
  ///
  ///
  const TextEditWidget({
    super.key,
    this.value = '',
    this.onComplete,
    this.labelText,
    this.errorText,
    this.editable = true,
    this.style,
  });
  //
  //
  @override
  State<TextEditWidget> createState() => _TextEditWidgetState();
}
//
//
class _TextEditWidgetState extends State<TextEditWidget> {
  late final TextEditingController _controller;
  bool _isChanged = false;
  //
  //
  @override
  void initState() {
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
    return TapRegion(
      onTapOutside: (PointerDownEvent _) {
        _onEditingComplete(_controller.text);
      },
      child: TextField(
        controller: _controller,
        enabled: widget.editable,
        style: _isChanged 
          ? (widget.style ?? Theme.of(context).textTheme.titleMedium)?.copyWith(color: Colors.blue)
          : null,
        // textAlign: _textAlign,
        decoration: InputDecoration(
          // border: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: _isChanged ? Colors.red.withValue(alpha: 0.5) : Colors.black.withValue(alpha: 0.5))),
          // border: const OutlineInputBorder(),
          isDense: true,
          labelText: widget.labelText,
          filled: true,
          fillColor: Colors.transparent,
          hoverColor: Theme.of(context).hoverColor,
          errorText: widget.errorText,
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        onChanged: (value) {
          final isChanged = value != widget.value;
          if (_isChanged != isChanged) {
            _isChanged = isChanged;
            setState(() {return;});
          }
        },
        onTapOutside: (_) {
          _onEditingComplete(_controller.text);
        },
        onEditingComplete: () {
          _onEditingComplete(_controller.text);
        },
      ),
    );
  }
  ///
  ///
  _onEditingComplete(String value) {
    if (value != widget.value) {
      final onComplete = widget.onComplete;
      if (onComplete != null) onComplete(value);
    }
  }
}