
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
  bool _isEditing = false;
  late final TextEditingController _controller = TextEditingController();
  ///
  ///
  @override
  void initState() {
    _controller.text = widget._value;
    super.initState();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.text = widget._value;
          _isEditing = true;
        });
      },
      child: _isEditing
        ? TextField(
          controller: _controller,
           decoration: InputDecoration(
            border: OutlineInputBorder(),
            // labelText: 'Password',
          ),
          onEditingComplete: () {
            setState(() {
              _isEditing = false;
            });
            final onComplete = widget._onComplete;
            if (onComplete != null) onComplete(_controller.text);
          },
        )
        : Text(
          _controller.text,
          style: widget._stile,
        ),
    );
  }
}

///
///
class TRow extends StatelessWidget {
  final List<TCell> _cells;
  const TRow({
    super.key,
    required List<TCell> cells,
  }) :
    _cells = cells;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildCells(context, _cells),
    );
  }
  ///
  ///
  List<Widget> _buildCells(BuildContext context, List<TCell> cells) {
    return cells.map((cell) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.5, horizontal: 2.5),
        decoration: BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(),
          ),
        ),
        child: cell,
      );
    }).toList();
  }
}

