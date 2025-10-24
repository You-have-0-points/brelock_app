import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Brelock'**
  String get appTitle;

  /// No description provided for @newCategory.
  ///
  /// In ru, this message translates to:
  /// **'Новая категория'**
  String get newCategory;

  /// No description provided for @categoryName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get categoryName;

  /// No description provided for @add.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get add;

  /// No description provided for @enterFolderName.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя папки'**
  String get enterFolderName;

  /// No description provided for @folderAlreadyExists.
  ///
  /// In ru, this message translates to:
  /// **'Папка с таким именем уже существует'**
  String get folderAlreadyExists;

  /// No description provided for @changePassword.
  ///
  /// In ru, this message translates to:
  /// **'Смена пароля'**
  String get changePassword;

  /// No description provided for @forr.
  ///
  /// In ru, this message translates to:
  /// **'Для'**
  String get forr;

  /// No description provided for @newPassword.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get newPassword;

  /// No description provided for @repeatNewPassword.
  ///
  /// In ru, this message translates to:
  /// **'Повторите новый пароль'**
  String get repeatNewPassword;

  /// No description provided for @confirm.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get confirm;

  /// No description provided for @fillAllFields.
  ///
  /// In ru, this message translates to:
  /// **'Заполните все поля'**
  String get fillAllFields;

  /// No description provided for @passwordMinLength.
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен содержать минимум 6 символов'**
  String get passwordMinLength;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get passwordsNotMatch;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Пароль успешно изменен'**
  String get passwordChangedSuccess;

  /// Сообщение об ошибке при изменении пароля
  ///
  /// In ru, this message translates to:
  /// **'Ошибка при изменении пароля: {error}'**
  String passwordChangeError(Object error);

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get back;

  /// No description provided for @changingPasswordAgreement.
  ///
  /// In ru, this message translates to:
  /// **'Изменяя пароль, вы соглашаетесь с'**
  String get changingPasswordAgreement;

  /// No description provided for @privacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Политикой конфиденциальности'**
  String get privacyPolicy;

  /// No description provided for @passwordRecovery.
  ///
  /// In ru, this message translates to:
  /// **'Восстановление пароля'**
  String get passwordRecovery;

  /// No description provided for @enterEmailForCode.
  ///
  /// In ru, this message translates to:
  /// **'Введите ваш email для отправки кода подтверждения'**
  String get enterEmailForCode;

  /// No description provided for @emailAddress.
  ///
  /// In ru, this message translates to:
  /// **'Email-адрес'**
  String get emailAddress;

  /// No description provided for @supportedServices.
  ///
  /// In ru, this message translates to:
  /// **'Поддерживаемые сервисы: Gmail, Yandex'**
  String get supportedServices;

  /// No description provided for @sendCode.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код'**
  String get sendCode;

  /// Сообщение о отправке кода на email
  ///
  /// In ru, this message translates to:
  /// **'На почту {email} отправлено письмо с кодом подтверждения'**
  String codeSentToEmail(Object email);

  /// Сообщение о том, через какой сервис отправлено письмо
  ///
  /// In ru, this message translates to:
  /// **'Письмо отправлено через {service}'**
  String emailSentVia(Object service);

  /// No description provided for @confirmationCode.
  ///
  /// In ru, this message translates to:
  /// **'Код подтверждения'**
  String get confirmationCode;

  /// No description provided for @resendCode.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код повторно'**
  String get resendCode;

  /// Таймер повторной отправки кода
  ///
  /// In ru, this message translates to:
  /// **'Отправить повторно через {seconds} сек.'**
  String resendInSeconds(Object seconds);

  /// No description provided for @backToLogin.
  ///
  /// In ru, this message translates to:
  /// **'Назад к входу'**
  String get backToLogin;

  /// No description provided for @recoveringPasswordAgreement.
  ///
  /// In ru, this message translates to:
  /// **'Восстанавливая пароль, вы соглашаетесь с'**
  String get recoveringPasswordAgreement;

  /// No description provided for @codeVerifiedSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Код подтвержден успешно'**
  String get codeVerifiedSuccess;

  /// No description provided for @wrongCode.
  ///
  /// In ru, this message translates to:
  /// **'Неверный код подтверждения'**
  String get wrongCode;

  /// No description provided for @codeVerificationError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка проверки кода: {error}'**
  String codeVerificationError(Object error);

  /// No description provided for @codeResent.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен повторно'**
  String get codeResent;

  /// No description provided for @generation.
  ///
  /// In ru, this message translates to:
  /// **'Генерация'**
  String get generation;

  /// Длина пароля в генераторе
  ///
  /// In ru, this message translates to:
  /// **'Длина: {length}'**
  String length(Object length);

  /// No description provided for @letters.
  ///
  /// In ru, this message translates to:
  /// **'Буквы'**
  String get letters;

  /// No description provided for @digits.
  ///
  /// In ru, this message translates to:
  /// **'Цифры'**
  String get digits;

  /// No description provided for @specialSymbols.
  ///
  /// In ru, this message translates to:
  /// **'Специальные символы'**
  String get specialSymbols;

  /// No description provided for @apply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get apply;

  /// No description provided for @login.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get login;

  /// No description provided for @masterPassword.
  ///
  /// In ru, this message translates to:
  /// **'Мастер-пароль'**
  String get masterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get signIn;

  /// No description provided for @noAccount.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта?'**
  String get noAccount;

  /// No description provided for @registration.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get registration;

  /// No description provided for @loginAgreement.
  ///
  /// In ru, this message translates to:
  /// **'Входя, вы соглашаетесь с'**
  String get loginAgreement;

  /// No description provided for @wrongLoginOrPassword.
  ///
  /// In ru, this message translates to:
  /// **'Неверный логин или пароль'**
  String get wrongLoginOrPassword;

  /// No description provided for @loginSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Вход успешно выполнен'**
  String get loginSuccess;

  /// No description provided for @securitySettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки безопасности'**
  String get securitySettings;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @russian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get russian;

  /// No description provided for @email.
  ///
  /// In ru, this message translates to:
  /// **'Почта'**
  String get email;

  /// No description provided for @twoFactorAuth.
  ///
  /// In ru, this message translates to:
  /// **'Двухфакторная аутентификация'**
  String get twoFactorAuth;

  /// No description provided for @disabled.
  ///
  /// In ru, this message translates to:
  /// **'Отключено'**
  String get disabled;

  /// No description provided for @changeMasterPassword.
  ///
  /// In ru, this message translates to:
  /// **'Сменить мастер-пароль'**
  String get changeMasterPassword;

  /// No description provided for @connection.
  ///
  /// In ru, this message translates to:
  /// **'Подключение'**
  String get connection;

  /// No description provided for @scanQRCode.
  ///
  /// In ru, this message translates to:
  /// **'Отсканируйте QR-код в приложении аутентификации'**
  String get scanQRCode;

  /// No description provided for @cantScan.
  ///
  /// In ru, this message translates to:
  /// **'Не получается отсканировать код?'**
  String get cantScan;

  /// No description provided for @copySecretKey.
  ///
  /// In ru, this message translates to:
  /// **'скопируйте секретный ключ'**
  String get copySecretKey;

  /// No description provided for @andCompleteSetup.
  ///
  /// In ru, this message translates to:
  /// **' и завершите настройку вручную'**
  String get andCompleteSetup;

  /// No description provided for @enterVerificationCode.
  ///
  /// In ru, this message translates to:
  /// **'Введите код подтверждения из приложения'**
  String get enterVerificationCode;

  /// No description provided for @connect.
  ///
  /// In ru, this message translates to:
  /// **'Подключить'**
  String get connect;

  /// No description provided for @your2FASecret.
  ///
  /// In ru, this message translates to:
  /// **'Ваш секретный ключ 2FA'**
  String get your2FASecret;

  /// No description provided for @passwordData.
  ///
  /// In ru, this message translates to:
  /// **'Данные пароля'**
  String get passwordData;

  /// No description provided for @url.
  ///
  /// In ru, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @username.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get username;

  /// No description provided for @password.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @serviceName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get serviceName;

  /// No description provided for @deletePassword.
  ///
  /// In ru, this message translates to:
  /// **'Удалить пароль?'**
  String get deletePassword;

  /// Подтверждение удаления пароля
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите удалить пароль \"{passwordName}\"? Это действие нельзя отменить.'**
  String deleteConfirmation(Object passwordName);

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @copy.
  ///
  /// In ru, this message translates to:
  /// **'Копировать'**
  String get copy;

  /// No description provided for @showPassword.
  ///
  /// In ru, this message translates to:
  /// **'Показать пароль'**
  String get showPassword;

  /// Сообщение о копировании в буфер обмена
  ///
  /// In ru, this message translates to:
  /// **'{field} скопирован в буфер обмена'**
  String copiedToClipboard(Object field);

  /// No description provided for @searchPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Поиск паролей...'**
  String get searchPasswords;

  /// No description provided for @nothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get nothingFound;

  /// No description provided for @tryDifferentQuery.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте изменить запрос'**
  String get tryDifferentQuery;

  /// No description provided for @favorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get favorites;

  /// No description provided for @registrationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get registrationTitle;

  /// No description provided for @repeatMasterPassword.
  ///
  /// In ru, this message translates to:
  /// **'Повторите мастер-пароль'**
  String get repeatMasterPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт?'**
  String get alreadyHaveAccount;

  /// No description provided for @register.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get register;

  /// No description provided for @registrationAgreement.
  ///
  /// In ru, this message translates to:
  /// **'Регистрируясь, вы соглашаетесь с'**
  String get registrationAgreement;

  /// No description provided for @enterEmail.
  ///
  /// In ru, this message translates to:
  /// **'Введите email-адрес'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In ru, this message translates to:
  /// **'Введите корректный email-адрес'**
  String get enterValidEmail;

  /// No description provided for @passwordLatinOnly.
  ///
  /// In ru, this message translates to:
  /// **'Пароль может содержать только латинские буквы, цифры и специальные символы'**
  String get passwordLatinOnly;

  /// No description provided for @passwordMin8Chars.
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен содержать от 8 символов'**
  String get passwordMin8Chars;

  /// No description provided for @userAlreadyExists.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь с такой почтой уже существует'**
  String get userAlreadyExists;

  /// Общее сообщение при тапе
  ///
  /// In ru, this message translates to:
  /// **'Тапнуто'**
  String get tapped;

  /// Сообщение при тапе на язык в настройках
  ///
  /// In ru, this message translates to:
  /// **'Тапнуто на язык'**
  String get tappedOnLanguage;

  /// No description provided for @success.
  ///
  /// In ru, this message translates to:
  /// **'Успешно'**
  String get success;

  /// No description provided for @pleaseEnterVerificationCode.
  ///
  /// In ru, this message translates to:
  /// **'Пожалуйста, введите код для верификации'**
  String get pleaseEnterVerificationCode;

  /// No description provided for @verificationCodeMustBe6Digits.
  ///
  /// In ru, this message translates to:
  /// **'Код должен состоять из 6 цифр'**
  String get verificationCodeMustBe6Digits;

  /// No description provided for @chooseExportFormat.
  ///
  /// In ru, this message translates to:
  /// **'Выберите формат экспорта'**
  String get chooseExportFormat;

  /// No description provided for @jsonFormatDescription.
  ///
  /// In ru, this message translates to:
  /// **'Структурированные данные с метаданными'**
  String get jsonFormatDescription;

  /// No description provided for @csvFormatDescription.
  ///
  /// In ru, this message translates to:
  /// **'Табличный формат для электронных таблиц'**
  String get csvFormatDescription;

  /// No description provided for @exportedPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Экспортированные пароли из Brelock'**
  String get exportedPasswords;

  /// No description provided for @exportSuccessful.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт успешно завершен'**
  String get exportSuccessful;

  /// No description provided for @exportError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка экспорта'**
  String get exportError;

  /// No description provided for @importPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Импорт паролей'**
  String get importPasswords;

  /// No description provided for @importConfirmation.
  ///
  /// In ru, this message translates to:
  /// **'Существующие пароли будут сохранены. Продолжить?'**
  String get importConfirmation;

  /// No description provided for @importComplete.
  ///
  /// In ru, this message translates to:
  /// **'Импорт завершен'**
  String get importComplete;

  /// No description provided for @importedCount.
  ///
  /// In ru, this message translates to:
  /// **'Импортировано {count} паролей'**
  String importedCount(Object count);

  /// No description provided for @importError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка импорта'**
  String get importError;

  /// No description provided for @unsupportedFileFormat.
  ///
  /// In ru, this message translates to:
  /// **'Неподдерживаемый формат файла'**
  String get unsupportedFileFormat;

  /// No description provided for @dataManagement.
  ///
  /// In ru, this message translates to:
  /// **'Управление данными'**
  String get dataManagement;

  /// No description provided for @exportDescription.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт всех паролей в файл'**
  String get exportDescription;

  /// No description provided for @importDescription.
  ///
  /// In ru, this message translates to:
  /// **'Импорт паролей из файла'**
  String get importDescription;

  /// No description provided for @security.
  ///
  /// In ru, this message translates to:
  /// **'Безопасность'**
  String get security;

  /// No description provided for @securitySettingsDescription.
  ///
  /// In ru, this message translates to:
  /// **'Расширенные настройки безопасности'**
  String get securitySettingsDescription;

  /// No description provided for @ok.
  ///
  /// In ru, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @import.
  ///
  /// In ru, this message translates to:
  /// **'Импорт'**
  String get import;

  /// No description provided for @breachCheck.
  ///
  /// In ru, this message translates to:
  /// **'Проверка безопасности'**
  String get breachCheck;

  /// No description provided for @checkingForBreaches.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем наличие утечек данных...'**
  String get checkingForBreaches;

  /// No description provided for @breachCheckDescription.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем, не были ли ваши пароли скомпрометированы в известных утечках данных'**
  String get breachCheckDescription;

  /// No description provided for @noBreachesFound.
  ///
  /// In ru, this message translates to:
  /// **'Утечек не найдено!'**
  String get noBreachesFound;

  /// No description provided for @breachesFound.
  ///
  /// In ru, this message translates to:
  /// **'Обнаружены потенциальные утечки'**
  String get breachesFound;

  /// No description provided for @checkedPasswordsCount.
  ///
  /// In ru, this message translates to:
  /// **'Проверено {count} паролей'**
  String checkedPasswordsCount(Object count);

  /// No description provided for @allPasswordsSecure.
  ///
  /// In ru, this message translates to:
  /// **'Все пароли защищены'**
  String get allPasswordsSecure;

  /// No description provided for @noCompromisedPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Ваши пароли не найдены в известных утечках данных'**
  String get noCompromisedPasswords;

  /// No description provided for @compromisedPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Скомпрометированные пароли: {count}'**
  String compromisedPasswords(Object count);

  /// No description provided for @breachSource.
  ///
  /// In ru, this message translates to:
  /// **'Источник утечки'**
  String get breachSource;

  /// No description provided for @breachDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата утечки'**
  String get breachDate;

  /// No description provided for @whatToDo.
  ///
  /// In ru, this message translates to:
  /// **'Что делать?'**
  String get whatToDo;

  /// No description provided for @breachActionAdvice.
  ///
  /// In ru, this message translates to:
  /// **'Немедленно измените эти пароли. Используйте надежные уникальные пароли для каждого сервиса.'**
  String get breachActionAdvice;

  /// No description provided for @recheckBreaches.
  ///
  /// In ru, this message translates to:
  /// **'Проверить снова'**
  String get recheckBreaches;

  /// No description provided for @howItWorks.
  ///
  /// In ru, this message translates to:
  /// **'Как это работает'**
  String get howItWorks;

  /// No description provided for @breachCheckInfo.
  ///
  /// In ru, this message translates to:
  /// **'Мы проверяем ваши пароли по базам данных известных утечек. Ваши пароли никогда не отправляются на внешние серверы.'**
  String get breachCheckInfo;

  /// No description provided for @lastChecked.
  ///
  /// In ru, this message translates to:
  /// **'Последняя проверка: {date}'**
  String lastChecked(Object date);

  /// No description provided for @checkPasswordLeaks.
  ///
  /// In ru, this message translates to:
  /// **'Проверить на утечки паролей'**
  String get checkPasswordLeaks;

  /// No description provided for @safe.
  ///
  /// In ru, this message translates to:
  /// **'БЕЗОПАСНО'**
  String get safe;

  /// No description provided for @breachCheckError.
  ///
  /// In ru, this message translates to:
  /// **'Проверка не удалась'**
  String get breachCheckError;

  /// No description provided for @tryAgain.
  ///
  /// In ru, this message translates to:
  /// **'Попробовать снова'**
  String get tryAgain;

  /// No description provided for @passwordAnalytics.
  ///
  /// In ru, this message translates to:
  /// **'Аналитика паролей'**
  String get passwordAnalytics;

  /// No description provided for @overallSecurity.
  ///
  /// In ru, this message translates to:
  /// **'Общая безопасность'**
  String get overallSecurity;

  /// No description provided for @securityLevel.
  ///
  /// In ru, this message translates to:
  /// **'Уровень безопасности'**
  String get securityLevel;

  /// No description provided for @recommendations.
  ///
  /// In ru, this message translates to:
  /// **'Рекомендации'**
  String get recommendations;

  /// No description provided for @detailedStatistics.
  ///
  /// In ru, this message translates to:
  /// **'Детальная статистика'**
  String get detailedStatistics;

  /// No description provided for @totalPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Всего паролей'**
  String get totalPasswords;

  /// No description provided for @strongPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Надежные пароли'**
  String get strongPasswords;

  /// No description provided for @mediumPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Средние пароли'**
  String get mediumPasswords;

  /// No description provided for @weakPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Слабые пароли'**
  String get weakPasswords;

  /// No description provided for @averageLength.
  ///
  /// In ru, this message translates to:
  /// **'Средняя длина'**
  String get averageLength;

  /// No description provided for @reusedPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Повторяющиеся пароли'**
  String get reusedPasswords;

  /// No description provided for @oldPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Устаревшие пароли'**
  String get oldPasswords;

  /// No description provided for @weakPasswordsFound.
  ///
  /// In ru, this message translates to:
  /// **'Слабые пароли обнаружены'**
  String get weakPasswordsFound;

  /// No description provided for @reusedPasswordsFound.
  ///
  /// In ru, this message translates to:
  /// **'Повторяющиеся пароли'**
  String get reusedPasswordsFound;

  /// No description provided for @oldPasswordsFound.
  ///
  /// In ru, this message translates to:
  /// **'Устаревшие пароли'**
  String get oldPasswordsFound;

  /// No description provided for @shortPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Короткие пароли'**
  String get shortPasswords;

  /// No description provided for @strengthen.
  ///
  /// In ru, this message translates to:
  /// **'Усилить'**
  String get strengthen;

  /// No description provided for @change.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get change;

  /// No description provided for @update.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get update;

  /// No description provided for @lengthen.
  ///
  /// In ru, this message translates to:
  /// **'Удлинить'**
  String get lengthen;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
