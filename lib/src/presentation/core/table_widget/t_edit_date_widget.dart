
import 'package:flowers_admin/src/presentation/core/edit_widgets/date_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/hover_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
///
/// Drop-downd editable list used in the form
class TEditDateWidget extends StatefulWidget {
  final String value;
  final TextStyle? style;
  final void Function(String value)? onComplete;
  final String? labelText;
  final bool editable;
  final String divider;
  ///
  ///
  const TEditDateWidget({
    super.key,
    required this.value,
    this.style,
    this.onComplete,
    this.labelText,
    this.editable = true,
    this.divider = '-',
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<TEditDateWidget> createState() => _TEditListWidgetState();
}
//
//
class _TEditListWidgetState extends State<TEditDateWidget> {
  // final _log = Log('$runtimeType');
  final _textPaddingH = 0.0;
  final _textPaddingV = 8.0;
  final _textAlign = TextAlign.justify;
  late final DateFormat _format;
  late final DateTime _value;
  late final DateTime? _widgetValue;
  bool _isEditing = false;
  bool _isChanged = false;
  //
  //
  @override
  void initState() {
    final d = widget.divider;
    _widgetValue = DateFormat('yyyy-MM-dd').tryParse(widget.value);
    _value = _widgetValue ?? DateTime.now();
    _format = DateFormat('dd${d}MM${d}yyyy');
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;
    final style = widget.editable
      ? widget.style ?? defaultStyle
      : (widget.style ?? defaultStyle)?.copyWith(color: (widget.style ?? defaultStyle)?.color?.withValues(alpha: 0.5));
    if (_isEditing) {
      return TapRegion(
        onTapOutside: (PointerDownEvent _) {
          if (_isEditing) {
            setState(() {
              _isEditing = false;
            });
          }
        },
        child: DateEditWidget(
          value: _widgetValue,
          // style: widget.style,
          onComplete: (value) {
            _applyNewValue(value, widget.onComplete);
          },
        )
      );
    }
    return GestureDetector(
      onTap: switchToEditing,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isEditing && widget.labelText != null)
                Text(
                  '${widget.labelText}',
                  style: Theme.of(context).inputDecorationTheme.labelStyle ?? Theme.of(context).textTheme.bodySmall,
                ),
              HoverBuilder(
                builder: (BuildContext context, bool isHovered) {
                  return Text(
                    _format.format(_value),
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
    if (widget.editable) {
      setState(() {
        _isEditing = true;
      });
    }
  }
  ///
  ///
  _applyNewValue(DateTime value, Function(String)? onComplete) {
    final widgetValue = _format.tryParse(widget.value);
    if (value != widgetValue) {
      _isChanged = true;
      _value = value;
      if (onComplete != null) onComplete(_format.format(value));
    }
  }
}
