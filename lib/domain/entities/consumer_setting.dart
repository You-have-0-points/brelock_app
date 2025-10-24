import 'package:brelock/domain/enums/language.dart';
import 'package:brelock/domain/enums/themes.dart';

class ConsumerSetting{
  Theme theme = Theme.DARK;
  Language language = Language.RUSSIAN;
  Duration autoLockTimeout = Duration(hours: 24);
  bool showPasswordStrength = true;

  ConsumerSetting(this.theme, this.language, this.autoLockTimeout, this.showPasswordStrength);

  ConsumerSetting.withTheme(this.theme){
    language = Language.RUSSIAN;
    autoLockTimeout = Duration(hours: 24); //TODO: set normal autolock timeout
    showPasswordStrength = true;
  }

  void updateTheme(Theme theme){
    this.theme = theme;
  }

  void updateLanguage(Language language){
    this.language = language;
  }

  void updateAutoLockTimeout(Duration duration){
    this.autoLockTimeout = duration;
  }

  void updateShowPasswordStrength(bool flag){
    this.showPasswordStrength = flag;
  }
}
