class Field {
  String _name;
  Field({
    required String name,
  }) :
    _name = name;
  ///
  ///
  String get key => _name;
}