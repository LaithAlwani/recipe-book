// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_ok => 'OK';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get auth_title => 'Hungry';

  @override
  String get auth_login => 'Login';

  @override
  String get auth_register => 'SignUp';

  @override
  String get auth_login_title => 'Sign in to your account';

  @override
  String get auth_signup_title => 'Sign up for a new account';

  @override
  String get auth_email_label => 'Email';

  @override
  String get auth_email_error => 'please enter your email';

  @override
  String get auth_password_lable => 'Password';

  @override
  String get auth_password_error => 'please enter a password';

  @override
  String get auth_no_account => 'Don\'t have an account?';

  @override
  String get auth_account => 'Have an account?';

  @override
  String get auth_login_social => 'or sign in with';

  @override
  String get auth_password_length => 'Password must be 8 characters in length';

  @override
  String get auth_check_input => 'Please check input';

  @override
  String get recipe_title => 'Recipes';

  @override
  String get recipe_add => 'Add Recipe';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_language => 'Language';
}
