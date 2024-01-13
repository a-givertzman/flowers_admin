import 'package:flutter/material.dart';

///
///
class TextEditWidget extends StatefulWidget {
  final String _value;
  final Function(String)? _onComplete;
  final String? _labelText;
  final String? _errorText;
  ///
  ///
  const TextEditWidget({
    super.key,
    String? value = '',
    Function(String)? onComplete,
    String? labelText,
    String? errorText,
  }):
    _value = value ?? '',
    _onComplete = onComplete,
    _labelText = labelText,
    _errorText = errorText;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<TextEditWidget> createState() => _TextEditWidgetState(
    value: _value,
    onComplete: _onComplete,
    labelText: _labelText,
    errorText: _errorText,
  );
}
///
///
class _TextEditWidgetState extends State<TextEditWidget> {
  final Function(String)? _onComplete;
  final TextEditingController _controller;
  final String? _labelText;
  final String? _errorText;
  final String _value;
  bool _isChanged = false;
  ///
  ///
  _TextEditWidgetState({
    required String value,
    required Function(String)? onComplete,
    required String? labelText,
    required String? errorText,
  }):
    _value = value,
    _controller = TextEditingController.fromValue(TextEditingValue(text: value)),
    _onComplete = onComplete,
    _labelText = labelText,
    _errorText = errorText;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        style: _isChanged 
          ? Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.error)
          : null,
        // textAlign: _textAlign,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH - 10.0),
          // border: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: _isChanged ? Colors.red : Colors.black)),
          // border: const OutlineInputBorder(),
          isDense: true,
          labelText: _labelText,
          errorText: _errorText,
        ),
        onChanged: (value) {
          setState(() {
            _isChanged = value != _value;
          });
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
    if (value != _value) {
      final onComplete = _onComplete;
      if (onComplete != null) onComplete(value);
    }
  }
}