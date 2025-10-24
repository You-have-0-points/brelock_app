// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Brelock';

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryName => 'Name';

  @override
  String get add => 'Add';

  @override
  String get enterFolderName => 'Enter folder name';

  @override
  String get folderAlreadyExists => 'Folder with this name already exists';

  @override
  String get changePassword => 'Change Password';

  @override
  String get forr => 'For';

  @override
  String get newPassword => 'New Password';

  @override
  String get repeatNewPassword => 'Repeat New Password';

  @override
  String get confirm => 'Confirm';

  @override
  String get fillAllFields => 'Fill all fields';

  @override
  String get passwordMinLength => 'Password must contain at least 6 characters';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String passwordChangeError(Object error) {
    return 'Error changing password: $error';
  }

  @override
  String get back => 'Back';

  @override
  String get changingPasswordAgreement => 'By changing password, you agree to';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get passwordRecovery => 'Password Recovery';

  @override
  String get enterEmailForCode => 'Enter your email to send verification code';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get supportedServices => 'Supported services: Gmail, Yandex';

  @override
  String get sendCode => 'Send Code';

  @override
  String codeSentToEmail(Object email) {
    return 'Code sent to $email';
  }

  @override
  String emailSentVia(Object service) {
    return 'Email sent via $service';
  }

  @override
  String get confirmationCode => 'Confirmation Code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendInSeconds(Object seconds) {
    return 'Resend in $seconds sec.';
  }

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get recoveringPasswordAgreement =>
      'By recovering password, you agree to';

  @override
  String get codeVerifiedSuccess => 'Code verified successfully';

  @override
  String get wrongCode => 'Wrong verification code';

  @override
  String codeVerificationError(Object error) {
    return 'Code verification error: $error';
  }

  @override
  String get codeResent => 'Code resent';

  @override
  String get generation => 'Generation';

  @override
  String length(Object length) {
    return 'Length: $length';
  }

  @override
  String get letters => 'Letters';

  @override
  String get digits => 'Digits';

  @override
  String get specialSymbols => 'Special Symbols';

  @override
  String get apply => 'Apply';

  @override
  String get login => 'Login';

  @override
  String get masterPassword => 'Master Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get noAccount => 'No account?';

  @override
  String get registration => 'Registration';

  @override
  String get loginAgreement => 'By logging in, you agree to';

  @override
  String get wrongLoginOrPassword => 'Wrong login or password';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get russian => 'Russian';

  @override
  String get email => 'Email';

  @override
  String get twoFactorAuth => 'Two-Factor Authentication';

  @override
  String get disabled => 'Disabled';

  @override
  String get changeMasterPassword => 'Change Master Password';

  @override
  String get connection => 'Connection';

  @override
  String get scanQRCode => 'Scan the QR code in your authenticator app';

  @override
  String get cantScan => 'Can\'t scan the code?';

  @override
  String get copySecretKey => 'copy the secret key';

  @override
  String get andCompleteSetup => ' and complete setup manually';

  @override
  String get enterVerificationCode => 'Enter verification code from app';

  @override
  String get connect => 'Connect';

  @override
  String get your2FASecret => 'Your 2FA Secret Key';

  @override
  String get passwordData => 'Password Data';

  @override
  String get url => 'URL';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get serviceName => 'Name';

  @override
  String get deletePassword => 'Delete Password?';

  @override
  String deleteConfirmation(Object passwordName) {
    return 'Are you sure you want to delete password \"$passwordName\"? This action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get copy => 'Copy';

  @override
  String get showPassword => 'Show Password';

  @override
  String copiedToClipboard(Object field) {
    return '$field copied to clipboard';
  }

  @override
  String get searchPasswords => 'Search passwords...';

  @override
  String get nothingFound => 'Nothing found';

  @override
  String get tryDifferentQuery => 'Try different query';

  @override
  String get favorites => 'Favorites';

  @override
  String get registrationTitle => 'Registration';

  @override
  String get repeatMasterPassword => 'Repeat Master Password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get register => 'Register';

  @override
  String get registrationAgreement => 'By registering, you agree to';

  @override
  String get enterEmail => 'Enter email address';

  @override
  String get enterValidEmail => 'Enter valid email address';

  @override
  String get passwordLatinOnly =>
      'Password can only contain Latin letters, numbers and special symbols';

  @override
  String get passwordMin8Chars => 'Password must contain at least 8 characters';

  @override
  String get userAlreadyExists => 'User with this email already exists';

  @override
  String get tapped => 'Tapped';

  @override
  String get tappedOnLanguage => 'Tapped on language';

  @override
  String get success => 'Success';

  @override
  String get pleaseEnterVerificationCode => 'Please, enter verification code';

  @override
  String get verificationCodeMustBe6Digits =>
      'Verification code must be 6 digits';

  @override
  String get chooseExportFormat => 'Choose export format';

  @override
  String get jsonFormatDescription => 'Structured data with metadata';

  @override
  String get csvFormatDescription => 'Table format for spreadsheets';

  @override
  String get exportedPasswords => 'Exported passwords from Brelock';

  @override
  String get exportSuccessful => 'Export completed successfully';

  @override
  String get exportError => 'Export error';

  @override
  String get importPasswords => 'Import passwords';

  @override
  String get importConfirmation =>
      'Existing passwords will be preserved. Continue?';

  @override
  String get importComplete => 'Import complete';

  @override
  String importedCount(Object count) {
    return 'Imported $count passwords';
  }

  @override
  String get importError => 'Import error';

  @override
  String get unsupportedFileFormat => 'Unsupported file format';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportDescription => 'Export all passwords to file';

  @override
  String get importDescription => 'Import passwords from file';

  @override
  String get security => 'Security';

  @override
  String get securitySettingsDescription => 'Advanced security options';

  @override
  String get ok => 'OK';

  @override
  String get import => 'Import';

  @override
  String get breachCheck => 'Security Check';

  @override
  String get checkingForBreaches => 'Checking for data breaches...';

  @override
  String get breachCheckDescription =>
      'We\'re checking if your passwords have been compromised in known data breaches';

  @override
  String get noBreachesFound => 'No breaches found!';

  @override
  String get breachesFound => 'Potential breaches found';

  @override
  String checkedPasswordsCount(Object count) {
    return 'Checked $count passwords';
  }

  @override
  String get allPasswordsSecure => 'All passwords are secure';

  @override
  String get noCompromisedPasswords =>
      'None of your passwords were found in known data breaches';

  @override
  String compromisedPasswords(Object count) {
    return 'Compromised passwords: $count';
  }

  @override
  String get breachSource => 'Breach source';

  @override
  String get breachDate => 'Breach date';

  @override
  String get whatToDo => 'What to do?';

  @override
  String get breachActionAdvice =>
      'Change these passwords immediately. Use strong, unique passwords for each service.';

  @override
  String get recheckBreaches => 'Re-check';

  @override
  String get howItWorks => 'How it works';

  @override
  String get breachCheckInfo =>
      'We check your passwords against databases of known security breaches. Your passwords are never sent to external servers.';

  @override
  String lastChecked(Object date) {
    return 'Last checked: $date';
  }

  @override
  String get checkPasswordLeaks => 'Check for password leaks';

  @override
  String get safe => 'SAFE';

  @override
  String get breachCheckError => 'Check failed';

  @override
  String get tryAgain => 'Try again';

  @override
  String get passwordAnalytics => 'Password Analytics';

  @override
  String get overallSecurity => 'Overall Security';

  @override
  String get securityLevel => 'Security Level';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get detailedStatistics => 'Detailed Statistics';

  @override
  String get totalPasswords => 'Total Passwords';

  @override
  String get strongPasswords => 'Strong Passwords';

  @override
  String get mediumPasswords => 'Medium Passwords';

  @override
  String get weakPasswords => 'Weak Passwords';

  @override
  String get averageLength => 'Average Length';

  @override
  String get reusedPasswords => 'Reused Passwords';

  @override
  String get oldPasswords => 'Old Passwords';

  @override
  String get weakPasswordsFound => 'Weak passwords found';

  @override
  String get reusedPasswordsFound => 'Reused passwords';

  @override
  String get oldPasswordsFound => 'Old passwords';

  @override
  String get shortPasswords => 'Short passwords';

  @override
  String get strengthen => 'Strengthen';

  @override
  String get change => 'Change';

  @override
  String get update => 'Update';

  @override
  String get lengthen => 'Lengthen';

  @override
  String get splashLoading => 'Loading...';

  @override
  String get offlineMode => 'Offline';

  @override
  String get logout => 'Log out';
}
