extension StrongOrDefault on String? {
  ///
  /// Returns string if it is not null and not empty, or [def]
  String orDefault(String def) {
    final me = this;
    if (me != null && me.isNotEmpty) {
      return me;
    }
    return def;
  }
}