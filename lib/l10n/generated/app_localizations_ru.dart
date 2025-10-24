// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Brelock';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get categoryName => 'Название';

  @override
  String get add => 'Добавить';

  @override
  String get enterFolderName => 'Введите имя папки';

  @override
  String get folderAlreadyExists => 'Папка с таким именем уже существует';

  @override
  String get changePassword => 'Смена пароля';

  @override
  String get forr => 'Для';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get repeatNewPassword => 'Повторите новый пароль';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get fillAllFields => 'Заполните все поля';

  @override
  String get passwordMinLength => 'Пароль должен содержать минимум 6 символов';

  @override
  String get passwordsNotMatch => 'Пароли не совпадают';

  @override
  String get passwordChangedSuccess => 'Пароль успешно изменен';

  @override
  String passwordChangeError(Object error) {
    return 'Ошибка при изменении пароля: $error';
  }

  @override
  String get back => 'Назад';

  @override
  String get changingPasswordAgreement => 'Изменяя пароль, вы соглашаетесь с';

  @override
  String get privacyPolicy => 'Политикой конфиденциальности';

  @override
  String get passwordRecovery => 'Восстановление пароля';

  @override
  String get enterEmailForCode =>
      'Введите ваш email для отправки кода подтверждения';

  @override
  String get emailAddress => 'Email-адрес';

  @override
  String get supportedServices => 'Поддерживаемые сервисы: Gmail, Yandex';

  @override
  String get sendCode => 'Отправить код';

  @override
  String codeSentToEmail(Object email) {
    return 'На почту $email отправлено письмо с кодом подтверждения';
  }

  @override
  String emailSentVia(Object service) {
    return 'Письмо отправлено через $service';
  }

  @override
  String get confirmationCode => 'Код подтверждения';

  @override
  String get resendCode => 'Отправить код повторно';

  @override
  String resendInSeconds(Object seconds) {
    return 'Отправить повторно через $seconds сек.';
  }

  @override
  String get backToLogin => 'Назад к входу';

  @override
  String get recoveringPasswordAgreement =>
      'Восстанавливая пароль, вы соглашаетесь с';

  @override
  String get codeVerifiedSuccess => 'Код подтвержден успешно';

  @override
  String get wrongCode => 'Неверный код подтверждения';

  @override
  String codeVerificationError(Object error) {
    return 'Ошибка проверки кода: $error';
  }

  @override
  String get codeResent => 'Код отправлен повторно';

  @override
  String get generation => 'Генерация';

  @override
  String length(Object length) {
    return 'Длина: $length';
  }

  @override
  String get letters => 'Буквы';

  @override
  String get digits => 'Цифры';

  @override
  String get specialSymbols => 'Специальные символы';

  @override
  String get apply => 'Применить';

  @override
  String get login => 'Логин';

  @override
  String get masterPassword => 'Мастер-пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get signIn => 'Войти';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get registration => 'Регистрация';

  @override
  String get loginAgreement => 'Входя, вы соглашаетесь с';

  @override
  String get wrongLoginOrPassword => 'Неверный логин или пароль';

  @override
  String get loginSuccess => 'Вход успешно выполнен';

  @override
  String get securitySettings => 'Настройки безопасности';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get russian => 'Русский';

  @override
  String get email => 'Почта';

  @override
  String get twoFactorAuth => 'Двухфакторная аутентификация';

  @override
  String get disabled => 'Отключено';

  @override
  String get changeMasterPassword => 'Сменить мастер-пароль';

  @override
  String get connection => 'Подключение';

  @override
  String get scanQRCode => 'Отсканируйте QR-код в приложении аутентификации';

  @override
  String get cantScan => 'Не получается отсканировать код?';

  @override
  String get copySecretKey => 'скопируйте секретный ключ';

  @override
  String get andCompleteSetup => ' и завершите настройку вручную';

  @override
  String get enterVerificationCode => 'Введите код подтверждения из приложения';

  @override
  String get connect => 'Подключить';

  @override
  String get your2FASecret => 'Ваш секретный ключ 2FA';

  @override
  String get passwordData => 'Данные пароля';

  @override
  String get url => 'URL';

  @override
  String get username => 'Логин';

  @override
  String get password => 'Пароль';

  @override
  String get serviceName => 'Название';

  @override
  String get deletePassword => 'Удалить пароль?';

  @override
  String deleteConfirmation(Object passwordName) {
    return 'Вы уверены, что хотите удалить пароль \"$passwordName\"? Это действие нельзя отменить.';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get close => 'Закрыть';

  @override
  String get copy => 'Копировать';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String copiedToClipboard(Object field) {
    return '$field скопирован в буфер обмена';
  }

  @override
  String get searchPasswords => 'Поиск паролей...';

  @override
  String get nothingFound => 'Ничего не найдено';

  @override
  String get tryDifferentQuery => 'Попробуйте изменить запрос';

  @override
  String get favorites => 'Избранное';

  @override
  String get registrationTitle => 'Регистрация';

  @override
  String get repeatMasterPassword => 'Повторите мастер-пароль';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get registrationAgreement => 'Регистрируясь, вы соглашаетесь с';

  @override
  String get enterEmail => 'Введите email-адрес';

  @override
  String get enterValidEmail => 'Введите корректный email-адрес';

  @override
  String get passwordLatinOnly =>
      'Пароль может содержать только латинские буквы, цифры и специальные символы';

  @override
  String get passwordMin8Chars => 'Пароль должен содержать от 8 символов';

  @override
  String get userAlreadyExists => 'Пользователь с такой почтой уже существует';

  @override
  String get tapped => 'Тапнуто';

  @override
  String get tappedOnLanguage => 'Тапнуто на язык';

  @override
  String get success => 'Успешно';

  @override
  String get pleaseEnterVerificationCode =>
      'Пожалуйста, введите код для верификации';

  @override
  String get verificationCodeMustBe6Digits => 'Код должен состоять из 6 цифр';

  @override
  String get chooseExportFormat => 'Выберите формат экспорта';

  @override
  String get jsonFormatDescription => 'Структурированные данные с метаданными';

  @override
  String get csvFormatDescription => 'Табличный формат для электронных таблиц';

  @override
  String get exportedPasswords => 'Экспортированные пароли из Brelock';

  @override
  String get exportSuccessful => 'Экспорт успешно завершен';

  @override
  String get exportError => 'Ошибка экспорта';

  @override
  String get importPasswords => 'Импорт паролей';

  @override
  String get importConfirmation =>
      'Существующие пароли будут сохранены. Продолжить?';

  @override
  String get importComplete => 'Импорт завершен';

  @override
  String importedCount(Object count) {
    return 'Импортировано $count паролей';
  }

  @override
  String get importError => 'Ошибка импорта';

  @override
  String get unsupportedFileFormat => 'Неподдерживаемый формат файла';

  @override
  String get dataManagement => 'Управление данными';

  @override
  String get exportDescription => 'Экспорт всех паролей в файл';

  @override
  String get importDescription => 'Импорт паролей из файла';

  @override
  String get security => 'Безопасность';

  @override
  String get securitySettingsDescription =>
      'Расширенные настройки безопасности';

  @override
  String get ok => 'OK';

  @override
  String get import => 'Импорт';

  @override
  String get breachCheck => 'Проверка безопасности';

  @override
  String get checkingForBreaches => 'Проверяем наличие утечек данных...';

  @override
  String get breachCheckDescription =>
      'Проверяем, не были ли ваши пароли скомпрометированы в известных утечках данных';

  @override
  String get noBreachesFound => 'Утечек не найдено!';

  @override
  String get breachesFound => 'Обнаружены потенциальные утечки';

  @override
  String checkedPasswordsCount(Object count) {
    return 'Проверено $count паролей';
  }

  @override
  String get allPasswordsSecure => 'Все пароли защищены';

  @override
  String get noCompromisedPasswords =>
      'Ваши пароли не найдены в известных утечках данных';

  @override
  String compromisedPasswords(Object count) {
    return 'Скомпрометированные пароли: $count';
  }

  @override
  String get breachSource => 'Источник утечки';

  @override
  String get breachDate => 'Дата утечки';

  @override
  String get whatToDo => 'Что делать?';

  @override
  String get breachActionAdvice =>
      'Немедленно измените эти пароли. Используйте надежные уникальные пароли для каждого сервиса.';

  @override
  String get recheckBreaches => 'Проверить снова';

  @override
  String get howItWorks => 'Как это работает';

  @override
  String get breachCheckInfo =>
      'Мы проверяем ваши пароли по базам данных известных утечек. Ваши пароли никогда не отправляются на внешние серверы.';

  @override
  String lastChecked(Object date) {
    return 'Последняя проверка: $date';
  }

  @override
  String get checkPasswordLeaks => 'Проверить на утечки паролей';

  @override
  String get safe => 'БЕЗОПАСНО';

  @override
  String get breachCheckError => 'Проверка не удалась';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get passwordAnalytics => 'Аналитика паролей';

  @override
  String get overallSecurity => 'Общая безопасность';

  @override
  String get securityLevel => 'Уровень безопасности';

  @override
  String get recommendations => 'Рекомендации';

  @override
  String get detailedStatistics => 'Детальная статистика';

  @override
  String get totalPasswords => 'Всего паролей';

  @override
  String get strongPasswords => 'Надежные пароли';

  @override
  String get mediumPasswords => 'Средние пароли';

  @override
  String get weakPasswords => 'Слабые пароли';

  @override
  String get averageLength => 'Средняя длина';

  @override
  String get reusedPasswords => 'Повторяющиеся пароли';

  @override
  String get oldPasswords => 'Устаревшие пароли';

  @override
  String get weakPasswordsFound => 'Слабые пароли обнаружены';

  @override
  String get reusedPasswordsFound => 'Повторяющиеся пароли';

  @override
  String get oldPasswordsFound => 'Устаревшие пароли';

  @override
  String get shortPasswords => 'Короткие пароли';

  @override
  String get strengthen => 'Усилить';

  @override
  String get change => 'Изменить';

  @override
  String get update => 'Обновить';

  @override
  String get lengthen => 'Удлинить';

  @override
  String get splashLoading => 'Загрузка...';

  @override
  String get offlineMode => 'Режим офлайн';

  @override
  String get logout => 'Выйти';
}
