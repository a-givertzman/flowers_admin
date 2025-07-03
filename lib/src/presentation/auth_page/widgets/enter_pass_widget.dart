import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flutter/material.dart';

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
  String _val = '';
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
              child: TextEditWidget(
                labelText: 'Enter your password'.inRu,
                value: '',
                onComplete: (value) {
                  _val = value;
                  widget.onComplete?.call(value);
                  // setState(() {return;});
                },
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
                onPressed: () {
                    // _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    // _log.debug('.TextButton.Yes | enrty: $_entry');
                    widget.onComplete?.call(_val);
                  },
                child: const Text("Yes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}