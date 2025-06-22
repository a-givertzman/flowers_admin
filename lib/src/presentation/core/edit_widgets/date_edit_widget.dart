import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
///
///
class DateEditWidget extends StatefulWidget {
  final DateTime? value;
  final Function(DateTime)? onComplete;
  final String? labelText;
  final String? errorText;
  final bool editable;
  final TextInputType? keyboardType;
  // final DateFormat? format;
  final String divider;
  ///
  /// Provides masked date input
  /// - [divider] - synbol divides date parts
  const DateEditWidget({
    super.key,
    this.value,
    this.onComplete,
    this.labelText,
    this.errorText,
    this.editable = true,
    this.keyboardType,
    // this.format,
    this.divider = '-',
  });
  //
  //
  @override
  State<DateEditWidget> createState() => _TextEditWidgetState();
}
//
//
class _TextEditWidgetState extends State<DateEditWidget> {
  late final Log _log;
  late final TextEditingController _controller;
  late final MaskTextInputFormatter _formatter;
  late final DateFormat _format;
  bool _isChanged = false;
  //
  //
  @override
  void initState() {
    _log = Log('$runtimeType');
    final d = widget.divider;
    _format = DateFormat('dd${d}MM${d}yyyy');
    final initialValue = _format.format(widget.value ?? DateTime.now());
    _formatter = MaskTextInputFormatter(
      mask: '##$d##$d####',
      filter: { "#": RegExp(r'[0-9]') },
      initialText: initialValue,
    );
    _controller = TextEditingController.fromValue(TextEditingValue(text: _formatter.getMaskedText()));
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
        _onEditingComplete(_controller.text, widget.onComplete);
        // _onEditingComplete(_formatter.getMaskedText(), widget.onComplete);
      },
      child: TextFormField(
        controller: _controller,
        enabled: widget.editable,
        style: _isChanged 
          ? Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue)
          : null,
        // textAlign: _textAlign,
        keyboardType: widget.keyboardType ?? TextInputType.datetime,
        inputFormatters: [
          // WhitelistingTextInputFormatter.digitsOnly,
          _formatter,
        ],
        autovalidateMode: AutovalidateMode.always,
        validator: _dateValidator,
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
          final date = _format.tryParse(value);
          final isChanged = date != widget.value;
          if (_isChanged != isChanged) {
            _isChanged = isChanged;
            setState(() {return;});
          }
          _log.warn('value: $value,  date: $date,  init: ${widget.value}');
        },
        onTapOutside: (_) {
          _onEditingComplete(_controller.text, widget.onComplete);
          // _onEditingComplete(_formatter.getMaskedText(), widget.onComplete);
        },
        onEditingComplete: () {
          _onEditingComplete(_controller.text, widget.onComplete);
          // _onEditingComplete(_formatter.getMaskedText(), widget.onComplete);
        },
      ),
    );
  }
  ///
  ///
  _onEditingComplete(String value, Function(DateTime)? onComplete) {
    final val = _format.tryParse(value);
    if (val != null) {
      if (val != widget.value) {
        if (onComplete != null) onComplete(val);
      }
    }
  }
  ///
  /// Returns Error message if date is not valid to specified [_format]
  String? _dateValidator(String? value) {
    final date = _format.tryParse(value ?? '');
    if (date != null) {
      return null;
    }
    return 'Invalid date format "${value}", Expected "${_format.pattern}"';
  }
}
