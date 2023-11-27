class FieldValue<T> {
  T _value;
  final FieldType _type;
  ///
  ///
  FieldValue(
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
  /// Returns true if changed
  bool update(T value) {
    if (_value != value) {
      _value = value;
      return true;
    }
    return false;
  }
}


enum FieldType {
  bool,
  int,
  double,
  string,
}