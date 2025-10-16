import 'package:brelock/domain/entities/consumer_setting.dart';
import 'package:brelock/domain/enums/themes.dart';
import 'package:brelock/domain/enums/language.dart';

class ConsumerSettingsTranslator{
  Map<String, dynamic> toDocument(ConsumerSetting setting){
    return {
      "theme": setting.theme.toString(),
      "language": setting.language.toString(),
      "show_password_strength": setting.showPasswordStrength.toString(),
      "auto_lock_timeout": setting.autoLockTimeout.toString()
    };
  }

  ConsumerSetting toEntity(Map<String, dynamic> settingData){
    Theme themeData = (settingData["theme"] == "DARK") ? Theme.DARK : Theme.LIGHT; //todo: FIX
    Language languageData = (settingData["language"] == "RUSSIAN") ? Language.RUSSIAN : Language.ENGLISH;
    Duration autoLockTimeoutData = _parseDuration(settingData["auto_lock_timeout"]!);
    bool showPasswordStrengthData = settingData["show_password_strength"] == "true";
    return ConsumerSetting(themeData, languageData, autoLockTimeoutData, showPasswordStrengthData);
  }

  Duration _parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}