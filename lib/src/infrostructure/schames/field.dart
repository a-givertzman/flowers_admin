class Field<T> {
  T _value;
  final FieldType _type;
  ///
  ///
  Field(
    T value, {
    FieldType type = FieldType.string,
  }) :
    _value = value,
    _type = type;
  ///
  ///
  T get value => _value;
  ///
  ///
  String? get str {
    if (_value == null) {
      return null;
    }
    switch (type) {
      case FieldType.bool:
        return '$_value';
      case FieldType.int:
        return '$_value';
      case FieldType.double:
        return '$_value';
      case FieldType.string:
        return "'$_value'";
      // default:
    }
  }

  ///
  ///
  FieldType get type => _type;
  ///
  ///
  void update(T value) {
    _value = value;
  }
}


enum FieldType {
  bool,
  int,
  double,
  string,
}