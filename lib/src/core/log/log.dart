import 'package:flowers_admin/src/core/log/console_colors.dart';
import 'package:flowers_admin/src/core/log/log_level.dart';
import 'package:logging/logging.dart';

export 'package:logging/logging.dart' hide Logger, Level;
///
/// Use a [Log] to log debug messages.
/// - First call initialize with optional root loging Level, default LogLevel.all
/// - [Log]s are named using a hierarchical dot-separated name convention.
class Log {
  final String _name;
  ///
  /// Create or find a Log by name.
  const Log(String name) : _name = name;
  ///
  /// Call to first initialization of the Log
  static void initialize({LogLevel? level}) {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = level ?? LogLevel.all; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      final color = switch (record.level) {
        LogLevel.all     => ConsoleColors.fgGray,
        LogLevel.trace   => ConsoleColors.fgCyan,
        LogLevel.debug   => ConsoleColors.fgBlue,
        LogLevel.config  => ConsoleColors.fgPurple,
        LogLevel.info    => ConsoleColors.fgGray,
        LogLevel.warning => ConsoleColors.fgYellow,
        LogLevel.error   => ConsoleColors.fgRed,
        _                => ConsoleColors.fgGray,
      };
      _logColored(color, '${record.time} | ${record.level.name} | ${record.loggerName}${record.message}');
    });
  }
  ///
  static void _logColored(String color, String message) {
      log(true, '$color$message${ConsoleColors.reset}');
  }
  ///
  /// Log message at level [LogLevel.trace].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void trace(Object? message, [Object? error, StackTrace? stackTrace]) =>
    Logger(_name).log(LogLevel.trace, message, error, stackTrace);
  ///
  /// Log message at level [LogLevel.debug].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void debug(Object? message, [Object? error, StackTrace? stackTrace]) =>
    Logger(_name).log(LogLevel.debug, message, error, stackTrace);
  ///
  /// Log message at level [LogLevel.info].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void info(Object? message, [Object? error, StackTrace? stackTrace]) =>
    Logger(_name).log(LogLevel.info, message, error, stackTrace);
  ///
  /// Log message at level [LogLevel.warning].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void warning(Object? message, [Object? error, StackTrace? stackTrace]) =>
    Logger(_name).log(LogLevel.warning, message, error, stackTrace);
  ///
  /// Log message at level [LogLevel.warning].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void warn(Object? message, [Object? error, StackTrace? stackTrace]) =>
    Logger(_name).log(LogLevel.warning, message, error, stackTrace);
  ///
  /// Log message at level [LogLevel.error].
  ///
  /// See [log] for information on how non-String [message] arguments are handled.
  void error(Object? message, [Object? error, StackTrace? stackTrace]) =>
    Logger(_name).log(LogLevel.error, message, error, stackTrace);
  ///
  /// Effective level considering the levels established in this logger's
  /// parents (when [hierarchicalLoggingEnabled] is true).
  LogLevel get level => Logger(_name).level as LogLevel;
  ///
  /// Override the level for this particular [Logger] and its children.
  ///
  /// Setting this to `null` makes it inherit the [parent]s level.
  set level(LogLevel? value) => Logger(_name).level = value;
}
/// if debug = true method prints messages to the debug consol 
/// works only in the debug mode
void log(
  bool debug,
  Object? message1, 
  [
    Object? message2, 
    Object? message3, 
  ]
) {
  assert(
    () {
      if (debug) {
        final String s1 = message1 != null ? message1.toString() : '';
        final String s2 = message2 != null ? message2.toString() : '';
        final String s3 = message3 != null ? message3.toString() : '';
        try {
          // ignore: avoid_print
          print(s1 + s2 + s3);
        } catch (e) {
          throw Exception('Ошибка в методе log(): $e');
        }
      }
      return true;
    } (),
    'Только в отладке',
  );
}
