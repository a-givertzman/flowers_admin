import 'package:logging/logging.dart';

/// [LogLevel]s to control logging output. Logging can be enabled to include all
/// levels above certain [LogLevel]. [LogLevel]s are ordered using an integer
/// value [LogLevel.value]. The predefined [LogLevel] constants below are sorted as
/// follows (in descending order): 
/// - [LogLevel.off], 
/// - [LogLevel.error], [LogLevel.warning], 
/// - [LogLevel.info], [LogLevel.config], [LogLevel.debug], [LogLevel.trace],
/// - [LogLevel.all].
///
/// We recommend using one of the predefined logging levels. If you define your
/// own level, make sure you use a value between those used in [Level.all] and
/// [Level.off].
class LogLevel extends Level {
  const LogLevel(super.name, super.value);
  /// Special key to turn on logging for all levels ([value] = 0).
  static const LogLevel all = LogLevel('ALL', 0);
  ///
  /// Key for detailed tracing information ([value] = 400).
  static const LogLevel trace = LogLevel('TRACE', 400);// Level.FINER;
  ///
  /// Key for tracing information ([value] = 500).
  static const LogLevel debug = LogLevel('DEBUG', 500);// Level.FINE;
  ///
  /// Key for static configuration messages ([value] = 700).
  static const LogLevel config = LogLevel('CONFIG', 700);
  ///
  /// Key for informational messages ([value] = 800).
  static const LogLevel info = LogLevel('INFO', 800);
  ///
  /// Key for potential problems ([value] = 900).
  static const LogLevel warning = LogLevel('WARNING', 900);
  ///
  /// Key for serious failures ([value] = 1000).
  static const LogLevel error = LogLevel('ERROR', 1000);
  ///
  /// Special key to turn off all logging ([value] = 2000).
  static const LogLevel off = LogLevel('OFF', 2000);
  //
  @override
  bool operator ==(Object other) => (other is Level) && value == other.value;
  //
  @override
  bool operator <(Level other) => value < other.value;
  //
  @override
  bool operator <=(Level other) => value <= other.value;
  //
  @override
  bool operator >(Level other) => value > other.value;
  //
  @override
  bool operator >=(Level other) => value >= other.value;
  //
  @override
  int compareTo(Level other) => value - other.value;
  //
  @override
  int get hashCode => value;
  //
  @override
  String toString() => name;
  ///
  static const List<LogLevel> levels = [
    all,
    trace,
    debug,
    config,
    info,
    warning,
    error,
    off,
  ];
}
