import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:abhrna/services/user_preferences.dart';
import 'package:abhrna/translations/locale_keys.g.dart';
import 'package:abhrna/widgets/country_city_selector.dart';
import 'package:abhrna/models/country.dart';
import 'package:abhrna/models/city.dart';

class LocationSummarySelector extends StatefulWidget {
  const LocationSummarySelector({super.key});

  @override
  State<LocationSummarySelector> createState() =>
      _LocationSummarySelectorState();
}

class _LocationSummarySelectorState extends State<LocationSummarySelector> {
  Country? _selectedCountry;
  City? _selectedCity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedLocation();
    });
  }

  Future<void> _loadSavedLocation() async {
    final (country, city) = await UserPreferences.loadLocationModels();

    setState(() {
      _selectedCountry = country;
      _selectedCity = city;
    });
  }

  void _openLocationDialog() {
    Country? tempSelectedCountry = _selectedCountry;
    City? tempSelectedCity = _selectedCity;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(LocaleKeys.select_location.tr()),
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : null,
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: CountryCitySelector(
                    onCitySelected: (city) {
                      setStateDialog(() {
                        tempSelectedCity = city;
                      });
                    },
                    onCountrySelected: (country) {
                      setStateDialog(() {
                        tempSelectedCountry = country;
                        tempSelectedCity = null;
                      });
                    },
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                FilledButton(
                  onPressed: tempSelectedCountry != null
                      ? () async {
                          await UserPreferences.saveLocationModels(
                            country: tempSelectedCountry!,
                            city: tempSelectedCity, // ممكن تكون null
                          );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          _loadSavedLocation();
                        }
                      : null,
                  child: Text(LocaleKeys.confirm.tr()),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // إلغاء
                  },
                  child: Text(LocaleKeys.cancel.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    String displayText;

    if (_selectedCountry != null && _selectedCity != null) {
      displayText =
          '${_selectedCountry!.name[locale]}, ${_selectedCity!.name[locale]}';
    } else if (_selectedCountry != null) {
      displayText =
          _selectedCountry!.name[locale] ?? _selectedCountry!.name['en']!;
    } else {
      displayText = LocaleKeys.select_location.tr();
    }

    return OutlinedButton.icon(
      icon: const Icon(Icons.location_on),
      onPressed: _openLocationDialog,
      // borderRadius: BorderRadius.circular(6),
      label: Text(
        displayText,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
