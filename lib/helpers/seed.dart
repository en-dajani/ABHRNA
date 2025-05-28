import 'package:cloud_firestore/cloud_firestore.dart';

class SaudiCitySeeder {
  static Future<void> run() async {
    final firestore = FirebaseFirestore.instance;

    // أضف الدولة
    await firestore.collection('countries').doc('saudi_arabia').set({
      'name': {'ar': 'السعودية', 'en': 'Saudi Arabia'},
    });

    final cities = [
      {'id': 'jeddah', 'ar': 'جدة', 'en': 'Jeddah'},
      {'id': 'yanbu', 'ar': 'ينبع', 'en': 'Yanbu'},
      {'id': 'jubail', 'ar': 'الجبيل', 'en': 'Jubail'},
      {'id': 'dammam', 'ar': 'الدمام', 'en': 'Dammam'},
      {'id': 'khobar', 'ar': 'الخبر', 'en': 'Khobar'},
      {'id': 'jazan', 'ar': 'جازان', 'en': 'Jazan'},
      {'id': 'qatif', 'ar': 'القطيف', 'en': 'Qatif'},
      {'id': 'rabigh', 'ar': 'رابغ', 'en': 'Rabigh'},
      {'id': 'al_lith', 'ar': 'الليث', 'en': 'Al Lith'},
      {'id': 'farasan', 'ar': 'فرسان', 'en': 'Farasan'},
      {'id': 'haql', 'ar': 'حقل', 'en': 'Haql'},
      {'id': 'dhuba', 'ar': 'ضباء', 'en': 'Duba'},
      {'id': 'alwajh', 'ar': 'الوجه', 'en': 'Al Wajh'},
      {'id': 'umluj', 'ar': 'أملج', 'en': 'Umluj'},
    ];

    for (final city in cities) {
      await firestore.collection('cities').doc(city['id']).set({
        'countryId': 'saudi_arabia',
        'name': {'ar': city['ar'], 'en': city['en']},
      });

      // ignore: avoid_print
      print('✅ تمت إضافة: ${city['ar']}');
    }

    // ignore: avoid_print
    print('🎉 تم إدخال جميع المدن السعودية الساحلية بنجاح!');
  }
}
