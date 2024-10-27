import 'app_settings.dart';
///
/// Holds setting value stored in AppSettings by it name
/// - value can be returned in int, double or string represantation 
class Setting {
  final String _name;
  final double _factor;
  ///
  /// - [name] - the name of value stored in AppSettings
  /// - [factor] - returned value int or double will by multiplied by factor
  const Setting(
    String name, {
    double factor = 1.0,
  }) : 
    _name = name,
    _factor = factor;
  ///
  /// 
  const factory Setting.from(dynamic value) = _SettingValue;
  /// 
  /// Returns setting value in int represantation
  int get toInt {
    final value = AppSettings.getSetting(_name);
    if (value is int) {
      return _factor == 1 ? value : (value * _factor).toInt();
    }
    return (double.parse('$value') * _factor).toInt();
  }
  /// 
  /// Returns setting value in double represantation
  double get toDouble {
    final value = AppSettings.getSetting(_name);
    if (value is double) {
      return value * _factor;
    }
    return double.parse('$value') * _factor;
  }
  /// 
  /// Returns setting value in string represantation
  @override
  String toString() => '${AppSettings.getSetting(_name)}';
}


class _SettingValue implements Setting {
  final dynamic _value;
  //
  const _SettingValue(dynamic value) : _value = value;
  //
  @override
  double get _factor => throw UnimplementedError();
  //
  @override
  String get _name => throw UnimplementedError();
  //
  @override
  double get toDouble {
    final value = _value;
    if (value is double) {
      return value;
    }
    return double.parse('$value');
  }
  //
  @override
  int get toInt {
    final value = _value;
    if (value is int) {
      return value;
    }
    return double.parse('$value').toInt();
  }
  //
  @override
  String toString() => '$_value';
}