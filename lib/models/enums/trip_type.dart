import 'package:easy_localization/easy_localization.dart';

/// أنواع الرحلات
enum TripType {
  picnic('picnic'),
  fishing('fishing'),
  diving('diving');

  final String key;
  const TripType(this.key);

  /// ترجمة اسم النوع حسب اللغة الحالية
  String get localized => key.tr();

  /// إرجاع القيمة كسلسلة نصية (بدون الترجمة)
  String get value => key;

  @override
  String toString() => localized;

  /// من String إلى TripType
  static TripType fromString(String value) {
    return TripType.values.firstWhere(
      (e) => e.key == value,
      orElse: () => throw Exception('Invalid trip type: $value'),
    );
  }

  /// من List\<String> إلى List\<TripType>
  static List<TripType> listFromStrings(List<String> list) {
    return list.map((e) => TripType.fromString(e)).toList();
  }

  /// من List\<TripType> إلى List\<String>
  static List<String> listToStrings(List<TripType> types) {
    return types.map((e) => e.key).toList();
  }
}
