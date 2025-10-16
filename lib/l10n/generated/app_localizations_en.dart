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
  String get twoFactorAuth => '2FA';

  @override
  String get disabled => 'Disabled';

  @override
  String get changeMasterPassword => 'Change Master Password';

  @override
  String get connection => 'Connection';

  @override
  String get scanQRCode => 'Scan QR code with authenticator app';

  @override
  String get cantScan => 'Can\'t scan?';

  @override
  String get copySecretKey => 'Copy secret key';

  @override
  String get andCompleteSetup => 'and complete setup manually';

  @override
  String get enterVerificationCode => 'Enter verification code from app';

  @override
  String get connect => 'Connect';

  @override
  String get your2FASecret => 'Your 2FA Secret';

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
}
