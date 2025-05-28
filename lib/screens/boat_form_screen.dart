// ✅ شاشة نموذج إضافة أو تعديل قارب محسنة ومنظمة
// تستخدم للإضافة أو التعديل حسب وجود موديل مسبق
// محسنة بتصميم أفضل و validation صحيح

import 'dart:io';
import 'package:abhrna/models/boat_model.dart';
import 'package:abhrna/models/enums/trip_type.dart';
import 'package:abhrna/models/address.dart';
import 'package:abhrna/models/country.dart';
import 'package:abhrna/models/city.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/widgets/app_text_form_field.dart';
import 'package:abhrna/widgets/country_city_selector.dart';
import 'package:abhrna/helpers/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BoatFormScreen extends StatefulWidget {
  final BoatModel? boat; // إذا كان موجود = تعديل، إذا null = إضافة جديدة

  const BoatFormScreen({super.key, this.boat});

  @override
  State<BoatFormScreen> createState() => _BoatFormScreenState();
}

class _BoatFormScreenState extends State<BoatFormScreen> {
  //════════════════════════════════════════════════════════════════════════════
  // المتغيرات والكونترولرز
  //════════════════════════════════════════════════════════════════════════════

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // الحقول الأساسية (مطلوبة)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();

  // الحقول الاختيارية
  final TextEditingController _descriptionController = TextEditingController();

  // قوائم البيانات
  List<TripType> _selectedTripTypes = [];
  final List<File> _newImages = []; // صور جديدة من الجهاز
  List<String> _existingImages = []; // صور محفوظة سابقًا في حالة التعديل

  // بيانات الموقع
  Country? _selectedCountry;
  City? _selectedCity;

  // متغيرات حالة validation
  bool _showCountryError = false;
  bool _showCityError = false;

  // حالات التطبيق
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  //════════════════════════════════════════════════════════════════════════════
  // دورة حياة الويدجت
  //════════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _pricePerHourController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //════════════════════════════════════════════════════════════════════════════
  // تهيئة البيانات
  //════════════════════════════════════════════════════════════════════════════

  void _initializeFormData() {
    if (widget.boat != null) {
      // تعبئة البيانات في حالة التعديل
      final boat = widget.boat!;
      _nameController.text = boat.name;
      _descriptionController.text = boat.description ?? '';
      _capacityController.text = boat.capacity.toString();
      _pricePerHourController.text = boat.pricePerHour.toString();
      _selectedTripTypes = List.from(boat.tripTypes);
      _existingImages = List.from(boat.images);

      // تهيئة بيانات الموقع إذا كانت متوفرة
      if (boat.address != null) {
        // TODO: تحديد الدولة والمدينة من Address
        // يمكن إضافة منطق هنا لاحقاً
      }
    }
  }

  //════════════════════════════════════════════════════════════════════════════
  // معالجة أنواع الرحلات
  //════════════════════════════════════════════════════════════════════════════

  void _toggleTripType(TripType type) {
    setState(() {
      if (_selectedTripTypes.contains(type)) {
        _selectedTripTypes.remove(type);
      } else {
        _selectedTripTypes.add(type);
      }
    });
  }

  //════════════════════════════════════════════════════════════════════════════
  // معالجة الصور
  //════════════════════════════════════════════════════════════════════════════

  Future<void> _pickImages() async {
    final totalImages = _newImages.length + _existingImages.length;

    if (totalImages >= 4) {
      if (mounted) {
        AppMessage.showError(context, LocaleKeys.max_4_images.tr());
      }
      return;
    }

    try {
      final picked = await _picker.pickMultiImage(imageQuality: 75);
      if (picked.isNotEmpty) {
        setState(() {
          final availableSlots = 4 - totalImages;
          if (availableSlots > 0) {
            _newImages.addAll(
              picked.take(availableSlots).map((e) => File(e.path)),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppMessage.showError(context, LocaleKeys.error.tr());
      }
    }
  }

  void _removeNewImage(File file) {
    setState(() {
      _newImages.remove(file);
    });
  }

  void _removeExistingImage(String url) {
    setState(() {
      _existingImages.remove(url);
    });
  }

  //════════════════════════════════════════════════════════════════════════════
  // معالجة الموقع
  //════════════════════════════════════════════════════════════════════════════

  void _onCountrySelected(Country country) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = null; // إعادة تعيين المدينة عند تغيير الدولة
      _showCountryError = false; // إخفاء رسالة خطأ الدولة
      _showCityError = false; // إخفاء رسالة خطأ المدينة
    });
    debugPrint('تم اختيار الدولة: ${country.name}');
    debugPrint('الدولة المختارة: $_selectedCountry != null');
    debugPrint('المدينة المختارة: $_selectedCity != null');
  }

  void _onCitySelected(City city) {
    setState(() {
      _selectedCity = city;
      _showCityError = false; // إخفاء رسالة خطأ المدينة
    });
    debugPrint('تم اختيار المدينة: ${city.name}');
    debugPrint('الدولة المختارة: $_selectedCountry != null');
    debugPrint('المدينة المختارة: $_selectedCity != null');
  }

  //════════════════════════════════════════════════════════════════════════════
  // حفظ البيانات
  //════════════════════════════════════════════════════════════════════════════

  Future<void> _saveBoat() async {
    // التحقق من صحة الفورم
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }

    // التحقق من وجود نوع رحلة واحد على الأقل
    if (_selectedTripTypes.isEmpty) {
      if (mounted) {
        AppMessage.showError(context, LocaleKeys.select_trip_types.tr());
      }
      return;
    }

    // التحقق من وجود صورة واحدة على الأقل
    if (_newImages.isEmpty && _existingImages.isEmpty) {
      if (mounted) {
        AppMessage.showError(context, LocaleKeys.add_boat_images.tr());
      }
      return;
    }

    // التحقق من اختيار الدولة والمدينة (إجباري)
    bool hasLocationError = false;

    // التحقق من أن الدولة والمدينة مطلوبة
    if (_selectedCountry == null || _selectedCity == null) {
      setState(() {
        _showCountryError = _selectedCountry == null;
        _showCityError =
            _selectedCity == null ||
            (_selectedCountry != null && _selectedCity == null);
      });
      hasLocationError = true;
      if (mounted) {
        if (_selectedCountry == null && _selectedCity == null) {
          AppMessage.showError(context, LocaleKeys.location_required.tr());
        } else if (_selectedCountry == null) {
          AppMessage.showError(context, LocaleKeys.country_required.tr());
        } else if (_selectedCity == null) {
          AppMessage.showError(context, LocaleKeys.city_required.tr());
        }
      }
    }

    // إذا فيه خطأ في الموقع، ارجع ولا تكمل
    if (hasLocationError) {
      return;
    }

    // إعادة تعيين حالة الأخطاء إذا كان كل شي صحيح
    setState(() {
      _showCountryError = false;
      _showCityError = false;
    });

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: تنفيذ منطق الحفظ

      // إنشاء عنوان إذا تم اختيار دولة ومدينة
      Address? address;
      if (_selectedCountry != null && _selectedCity != null) {
        // TODO: إنشاء Address object بناءً على الدولة والمدينة المختارة
        // address = Address(...);
      }

      // معلومات مؤقتة للاختبار
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        AppMessage.showSuccess(
          context,
          widget.boat == null
              ? LocaleKeys.boat_saved_successfully.tr()
              : LocaleKeys.save_changes.tr(),
        );

        // الرجوع للشاشة السابقة
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        AppMessage.showError(context, LocaleKeys.error.tr());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //════════════════════════════════════════════════════════════════════════════
  // دوال مساعدة
  //════════════════════════════════════════════════════════════════════════════

  void _scrollToFirstError() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //════════════════════════════════════════════════════════════════════════════
  // بناء واجهة المستخدم
  //════════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ═══════════════════════════════════════════════════════════════════════
      // شريط التطبيق
      // ═══════════════════════════════════════════════════════════════════════
      appBar: AppBar(
        title: Text(
          widget.boat == null
              ? LocaleKeys.add_boat.tr()
              : LocaleKeys.edit_boat.tr(),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // محتوى الشاشة
      // ═══════════════════════════════════════════════════════════════════════
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // البيانات الأساسية
              _buildBasicInfoSection(),
              const SizedBox(height: 24),

              // أنواع الرحلات
              _buildTripTypesSection(),
              const SizedBox(height: 24),

              // صور القارب
              _buildImagesSection(),
              const SizedBox(height: 24),

              // الموقع
              _buildLocationSection(),
              const SizedBox(height: 32),

              // أزرار الحفظ
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  //════════════════════════════════════════════════════════════════════════════
  // بناء أقسام الواجهة
  //════════════════════════════════════════════════════════════════════════════

  /// قسم البيانات الأساسية
  Widget _buildBasicInfoSection() {
    final locale = context.locale.languageCode;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions_boat,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  LocaleKeys.basic_boat_info.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // اسم القارب (مطلوب)
          AppTextFormField(
            prefixIcon: Icon(LucideIcons.ship),
            controller: _nameController,
            label: LocaleKeys.boat_name.tr(),
            validator: ValidationBuilder(localeName: locale)
                .required(LocaleKeys.boat_name_required.tr())
                .minLength(2, LocaleKeys.boat_name_min_length.tr())
                .maxLength(50, LocaleKeys.boat_name_max_length.tr())
                .build(),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // السعة (مطلوب)
              Expanded(
                child: AppTextFormField(
                  prefixIcon: Icon(LucideIcons.users),
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  label: LocaleKeys.capacity.tr(),
                  validator: ValidationBuilder(localeName: locale)
                      .required(LocaleKeys.capacity_required.tr())
                      .regExp(
                        RegExp(r'^[1-9]\d*$'),
                        LocaleKeys.capacity_invalid.tr(),
                      )
                      .build(),
                ),
              ),
              const SizedBox(width: 16),

              // السعر لكل ساعة (مطلوب)
              Expanded(
                child: AppTextFormField(
                  prefixIcon: Icon(LucideIcons.creditCard),
                  controller: _pricePerHourController,
                  keyboardType: TextInputType.number,
                  label: LocaleKeys.price_per_hour.tr(),
                  validator: ValidationBuilder(localeName: locale)
                      .required(LocaleKeys.price_required.tr())
                      .regExp(
                        RegExp(r'^\d+(\.\d{1,2})?$'),
                        LocaleKeys.price_invalid.tr(),
                      )
                      .build(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الوصف (اختياري)
          AppTextFormField(
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            maxLength: 500,
            maxLines: 4,
            label: LocaleKeys.description.tr(),
          ),
        ],
      ),
    );
  }

  /// قسم أنواع الرحلات
  Widget _buildTripTypesSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.sailing,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  LocaleKeys.trip_types.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.trip_types_help.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),

          // قائمة أنواع الرحلات
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: TripType.values.map((type) {
              final isSelected = _selectedTripTypes.contains(type);
              return FilterChip(
                label: Text(type.localized),
                selected: isSelected,
                onSelected: (_) => _toggleTripType(type),
                selectedColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).primaryColor,
              );
            }).toList(),
          ),

          // رسالة خطأ إذا لم يتم اختيار أي نوع
          if (_selectedTripTypes.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                LocaleKeys.select_trip_types.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// قسم صور القارب
  Widget _buildImagesSection() {
    final totalImages = _newImages.length + _existingImages.length;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  LocaleKeys.boat_images.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: totalImages > 0
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalImages/4',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: totalImages > 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.images_help.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),

          // عرض الصور
          if (totalImages > 0) ...[
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                // الصور الموجودة سابقاً
                ..._existingImages.map(
                  (url) => _buildImageCard(
                    child: Image.network(url, fit: BoxFit.cover),
                    onRemove: () => _removeExistingImage(url),
                  ),
                ),

                // الصور الجديدة
                ..._newImages.map(
                  (file) => _buildImageCard(
                    child: Image.file(file, fit: BoxFit.cover),
                    onRemove: () => _removeNewImage(file),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // زر إضافة صور
          if (totalImages < 4)
            SizedBox(
              width: double.infinity,
              height: 120,
              child: OutlinedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_a_photo, size: 32),
                label: Text(
                  totalImages == 0
                      ? LocaleKeys.add_images.tr()
                      : LocaleKeys.add_images.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

          // رسالة خطأ إذا لم يتم إضافة صور
          if (totalImages == 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                LocaleKeys.add_boat_images.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// بناء كارد صورة مع زر الحذف
  Widget _buildImageCard({
    required Widget child,
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: child,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  /// قسم الموقع
  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${LocaleKeys.location.tr()} *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.location_required_help.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),

          // اختيار الدولة والمدينة
          CountryCitySelector(
            isNew: widget.boat == null,
            onCountrySelected: _onCountrySelected,
            onCitySelected: _onCitySelected,
          ),

          // رسائل خطأ للموقع
          if (_showCityError &&
              _selectedCountry != null &&
              _selectedCity == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                LocaleKeys.city_required.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),

          if (_showCountryError &&
              _selectedCity != null &&
              _selectedCountry == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                LocaleKeys.country_required.tr(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 16),

          // زر اختيار الموقع من الخريطة (للمستقبل)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: افتح خريطة لاختيار الموقع
                if (mounted) {
                  AppMessage.showInfo(
                    context,
                    LocaleKeys.map_feature_coming_soon.tr(),
                  );
                }
              },
              icon: const Icon(Icons.map_outlined),
              label: Text(LocaleKeys.pick_location.tr()),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// أزرار العمليات
  Widget _buildActionButtons() {
    return Column(
      children: [
        // زر الحفظ
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: _isLoading ? null : _saveBoat,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(
              _isLoading
                  ? LocaleKeys.saving.tr()
                  : widget.boat == null
                  ? LocaleKeys.save_boat.tr()
                  : LocaleKeys.save_changes.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // زر الإلغاء
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.cancel_outlined),
            label: Text(
              LocaleKeys.cancel.tr(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
