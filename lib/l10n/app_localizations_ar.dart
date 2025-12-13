// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get common_ok => 'موافق';

  @override
  String get common_cancel => 'إلغاء';

  @override
  String get auth_title => 'جوعان';

  @override
  String get auth_login => 'تسجيل الدخول';

  @override
  String get auth_register => 'إنشاء حساب';

  @override
  String get auth_login_title => 'تسجيل الدخول إلى حسابك';

  @override
  String get auth_signup_title => 'سجّل للحصول على حساب جديد';

  @override
  String get auth_email_label => 'البريد الإلكتروني';

  @override
  String get auth_email_error => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get auth_password_lable => 'كلمة المرور';

  @override
  String get auth_password_error => 'يرجى إدخال كلمة المرور';

  @override
  String get auth_no_account => 'ليس لديك حساب؟';

  @override
  String get auth_account => 'هل لديك حساب؟';

  @override
  String get auth_login_social => 'أو تسجيل الدخول باستخدام';

  @override
  String get auth_password_length => 'يجب أن تكون كلمة المرور ٨ أحرف على الأقل';

  @override
  String get auth_check_input => 'يرجى التحقق من الإدخال';

  @override
  String get recipe_title => 'الوصفات';

  @override
  String get recipe_add => 'إضافة وصفة';

  @override
  String get settings_title => 'الإعدادات';

  @override
  String get settings_language => 'اللغة';
}
