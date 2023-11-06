import 'package:flowers_admin/src/core/error/failure.dart';
/// 
/// Containing either value of type [V] or error of type [E]
sealed class Result<V, E> {}
///
/// Containing either value of type [V] or [Failure]
typedef FailableResult<V> = Result<V, Failure>;
/// 
/// Successful [Result] with [value].
final class Ok<V, E> implements Result<V, E> {
  final V value;
  /// Successful [Result] with [value].
  const Ok(this.value);
}
/// 
/// Unsuccessful [Result] with [error].
final class Err<V, E> implements Result<V, E> {
  final E error;
  /// Unsuccessful [Result] with [error].
  const Err(this.error);
}