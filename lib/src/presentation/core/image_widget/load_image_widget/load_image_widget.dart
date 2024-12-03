import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
///
class LoadImageWidget extends StatefulWidget {
  final String _src;
  final Function(String)? _onComplete;
  final String? _labelText;
  final String? _errorText;
  ///
  ///
  const LoadImageWidget({
    super.key,
    String src = '',
    Function(String)? onComplete,
    String? labelText,
    String? errorText,
  }):
    _src = src,
    _onComplete = onComplete,
    _labelText = labelText,
    _errorText = errorText;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<LoadImageWidget> createState() => _LoadImageWidgetState(
    src: _src,
    onComplete: _onComplete,
    labelText: _labelText,
    errorText: _errorText,
  );
}
//
//
class _LoadImageWidgetState extends State<LoadImageWidget> {
  String _src;
  final Function(String)? _onComplete;
  final String? _labelText;
  String? _errorText;
  ///
  ///
  _LoadImageWidgetState({
    required String src,
    required Function(String)? onComplete,
    required String? labelText,
    required String? errorText,
  }):
    _src = src,
    _onComplete = onComplete,
    _labelText = labelText,
    _errorText = errorText;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextEditWidget(
                labelText: _labelText,
                value: _src,
                errorText: _errorText,
                onComplete: (value) {
                  switch (_fromGoogleDrive(value)) {
                    case Ok(:final value):
                      setState(() {
                        _src = value;
                      });
                    case Err(:final error):
                      setState(() {
                        _src = value;
                        _errorText = error.message;
                      });
                  }
                  final onComplete = _onComplete;
                  if (onComplete != null) {
                    onComplete(_src);
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          width: 300.0,
          height: 300.0,
          child: Image.network(
            _src,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null ? 
                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  ),
                );
              }
              return child;
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'Invalid link'.inRu,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  ///
  ///
  Result<String, Failure> _fromGoogleDrive(String url) {
    String pattern = r'file\/d\/(.*?)\/view';
    RegExp regExp = RegExp(pattern);
    final matches = regExp.allMatches(url);
    final fileId = matches.elementAtOrNull(0)?.group(1);
    if (fileId != null) {
      return Ok('https://drive.google.com/uc?export=view&id=$fileId');
    }
    return Err(Failure(
      message: '${'Invalid Google Drive url'.inRu} $url',
      stackTrace: StackTrace.current,
    ));
  }
}


