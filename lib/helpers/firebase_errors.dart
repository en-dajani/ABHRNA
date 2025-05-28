import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FirebaseErrors {
  static String getMessage(String code) {
    switch (code) {
      // 🔒 أخطاء المصادقة
      case 'invalid-email':
        return LocaleKeys.auth_error_invalid_email.tr();
      case 'user-disabled':
        return LocaleKeys.auth_error_user_disabled.tr();
      case 'user-not-found':
        return LocaleKeys.auth_error_user_not_found.tr();
      case 'wrong-password':
        return LocaleKeys.auth_error_wrong_password.tr();
      case 'email-already-in-use':
        return LocaleKeys.auth_error_email_in_use.tr();
      case 'weak-password':
        return LocaleKeys.auth_error_weak_password.tr();
      case 'too-many-requests':
        return LocaleKeys.auth_error_too_many_requests.tr();
      case 'network-request-failed':
        return LocaleKeys.auth_error_network.tr();
      case 'invalid-credential':
        return LocaleKeys.auth_error_invalid_credential.tr();

      // 🔥 أخطاء Firestore
      case 'permission-denied':
        return LocaleKeys.firestore_error_permission_denied.tr();
      case 'unavailable':
        return LocaleKeys.firestore_error_unavailable.tr();
      case 'cancelled':
        return LocaleKeys.firestore_error_cancelled.tr();
      case 'not-found':
        return LocaleKeys.firestore_error_not_found.tr();
      case 'deadline-exceeded':
        return LocaleKeys.firestore_error_timeout.tr();
      case 'already-exists':
        return LocaleKeys.firestore_error_already_exists.tr();
      case 'resource-exhausted':
        return LocaleKeys.firestore_error_resource_exhausted.tr();
      case 'unauthenticated':
        return LocaleKeys.firestore_error_unauthenticated.tr();
      case 'aborted':
        return LocaleKeys.firestore_error_aborted.tr();
      case 'internal':
        return LocaleKeys.firestore_error_internal.tr();
      case 'data-loss':
        return LocaleKeys.firestore_error_data_loss.tr();
      case 'failed-precondition':
        return LocaleKeys.firestore_error_failed_precondition.tr();
      case 'invalid-argument':
        return LocaleKeys.firestore_error_invalid_argument.tr();

      // 🌪️ غير معروف
      default:
        return LocaleKeys.firestore_error_unexpected.tr();
    }
  }
}
