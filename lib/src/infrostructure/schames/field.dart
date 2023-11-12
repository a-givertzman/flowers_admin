class Field {
  final String _key;
  final String _name;
  final bool _hidden;
  final bool _edit;
  const Field({
    required String key,
    String? name,
    bool hidden = false,
    bool edit = true,
  }) :
    _key = key,
    _name = name ?? key,
    _hidden = hidden,
    _edit = edit;
  ///
  ///
  String get key => _key;
  ///
  ///
  String get name => _name;
  ///
  ///
  bool get hidden => _hidden;
  ///
  ///
  bool get edit => _edit;
}