
import 'package:flowers_admin/src/presentation/core/hover_builder.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
// import 'package:hmi_core/hmi_core_log.dart';
///
/// Drop-downd editable list used in the form
class TEditListWidget extends StatefulWidget {
  final String? id;
  final EditListEntry relation;
  final TextStyle? style;
  final TextAlign textAlign;
  final void Function(String? value)? onComplete;
  // final void Function(String value)? _onSelectionChange;
  final String? labelText;
  final bool editable;
  ///
  /// Drop-downd editable list used in the form
  const TEditListWidget({
    super.key,
    required this.id,
    this.relation = const EditListEntry.empty(),
    this.style,
    this.textAlign = TextAlign.justify,
    this.onComplete,
    // this.onSelectionChange,
    this.labelText,
    this.editable = true,
  });
  //
  //
  @override
  State<TEditListWidget> createState() => _TEditListWidgetState();
}
//
//
class _TEditListWidgetState extends State<TEditListWidget> {
  // late final Log _log;
  String _id = '';
  final _textPaddingH = 0.0;
  final _textPaddingV = 8.0;
  bool _isEditing = false;
  bool _isChanged = false;
  //
  //
  @override
  void initState() {
    // _log = Log('$runtimeType');
    _id = widget.id ?? '';
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyLarge;
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
        child: DropdownButtonFormField(
              value: widget.relation.value(_id).isNotEmpty ? _id : '',
              items: {...{'': ''}, ...widget.relation.entry}.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: widget.style,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                _applyNewValue(value, widget.onComplete);
              },
              style: widget.style,
              iconSize: 0.0,
              isDense: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: _textPaddingV),
                labelText: widget.labelText,
                filled: true,
                fillColor: Colors.transparent,
                hoverColor: Theme.of(context).hoverColor,
        
              ),
            ),
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
                  final rel = widget.relation.value(_id);
                  return Text(
                    _id.isNotEmpty ? (rel.isNotEmpty ? rel : '') : '',
                    // _id.isNotEmpty ? (rel.isNotEmpty ? rel : '${InRu('Not sampled')}') : '${InRu('Not sampled')}',
                    style: _isChanged 
                      ? style?.copyWith(
                        backgroundColor: isHovered ? Theme.of(context).hoverColor : null,
                        color: Theme.of(context).colorScheme.error,
                      )
                      : style,
                    textAlign: widget.textAlign,
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
  _applyNewValue(String? id, void Function(String? value)? onComplete) {
    setState(() {
      _isEditing = false;
      if (id != _id) {
        _isChanged = true;
        _id = id ?? '';
      }
      if (onComplete != null) onComplete(id);
    });
  }
}
