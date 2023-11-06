/// 
/// Holds either value or nothing.
sealed class Option<T> {}
/// 
/// [Option] that holds value.
final class Some<T> implements Option<T> {
  final T value;
  ///
  /// Create [Option] object that holds [value].
  const Some(this.value);
}
/// 
/// [Option] that holds nothing.
final class None implements Option<Never> {
  /// 
  /// Create [Option] object that holds nothing.
  const None();
}