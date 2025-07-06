import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// Widget for enter and check password
class EnterPassWidget extends StatefulWidget {
  final AppUser user;
  final void Function(String)? onComplete;
  ///
  /// 
  const EnterPassWidget({
    super.key,
    required this.user,
    this.onComplete,
  });
  //
  @override
  State<EnterPassWidget> createState() => _EnterPassWidgetState();
}
//
class _EnterPassWidgetState extends State<EnterPassWidget> {
  final FocusNode _focusNode = FocusNode();
  String _val = '';
  bool _listenKeyPress = true;
  //
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 512, vertical: 256),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.user.name, style: Theme.of(context).textTheme.titleLarge,),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
              child: KeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKeyEvent: (KeyEvent event) {
                    if (event.logicalKey == LogicalKeyboardKey.enter) {
                      _listenKeyPress = false;
                      widget.onComplete?.call(_val);
                    } else if (_listenKeyPress && event.logicalKey == LogicalKeyboardKey.escape) {
                      Navigator.pop(context);
                    } else if (!_listenKeyPress) {
                      _listenKeyPress = true;
                    }
                },
                child: TextEditWidget(
                  labelText: 'Enter your password'.inRu,
                  value: '',
                  obscureText: true,
                  onChange: (value) {
                    _val = value;
                    _listenKeyPress = true;
                  }
                  // onComplete: (value) {
                  // },
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: OverflowBar(
            children: [
              TextButton(
                onPressed:  () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => widget.onComplete?.call(_val),
                  // {
                    // _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    // _log.debug('.TextButton.Yes | enrty: $_entry');
                    // widget.onComplete?.call(_val);
                  // },
                child: const Text("Yes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}