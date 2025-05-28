import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:abhrna/models/city.dart';
import 'package:abhrna/models/country.dart';
import 'package:abhrna/providers/location_provider.dart';
import 'package:abhrna/services/user_preferences.dart';
import 'package:abhrna/translations/locale_keys.g.dart';

class CountryCitySelector extends StatefulWidget {
  final void Function(City selectedCity)? onCitySelected;
  final void Function(Country selectedCountry)? onCountrySelected;
  final bool? isNew;

  const CountryCitySelector({
    super.key,
    this.onCitySelected,
    this.onCountrySelected,
    this.isNew = false,
  });

  @override
  State<CountryCitySelector> createState() => _CountryCitySelectorState();
}

class _CountryCitySelectorState extends State<CountryCitySelector> {
  Country? _selectedCountry;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    if (!widget.isNew!) {
      _restoreSavedLocation();
    }
  }

  Future<void> _restoreSavedLocation() async {
    final locationProvider = context.read<LocationProvider>();
    final (savedCountry, savedCity) =
        await UserPreferences.loadLocationModels();

    if (savedCountry != null) {
      setState(() => _selectedCountry = savedCountry);
      await locationProvider.loadCities(
        savedCountry.id,
        locale: context.locale.languageCode,
      );

      if (savedCity != null) {
        setState(() => _selectedCity = savedCity);
        widget.onCitySelected?.call(savedCity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final locationProvider = context.watch<LocationProvider>();
    final countries = locationProvider.countries;
    final cities = locationProvider.cities;

    return Column(
      children: [
        DropdownButtonFormField<Country>(
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyLarge,
          value: countries.any((c) => c.id == _selectedCountry?.id)
              ? countries.firstWhere((c) => c.id == _selectedCountry!.id)
              : null,
          decoration: InputDecoration(
            hintText: _selectedCountry == null ? LocaleKeys.country.tr() : null,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (newCountry) async {
            setState(() {
              _selectedCountry = newCountry;
              _selectedCity = null;
            });

            if (newCountry != null) {
              await locationProvider.loadCities(
                newCountry.id,
                locale: context.locale.languageCode,
              );

              widget.onCountrySelected?.call(newCountry);
            }
          },
          items: countries.map((country) {
            final name = country.name[locale] ?? country.name['en'] ?? '';
            return DropdownMenuItem(value: country, child: Text(name));
          }).toList(),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<City>(
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyLarge,
          value: cities.any((c) => c.id == _selectedCity?.id)
              ? cities.firstWhere((c) => c.id == _selectedCity!.id)
              : null,
          decoration: InputDecoration(
            hintText: _selectedCity == null ? LocaleKeys.city.tr() : null,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: _selectedCountry == null
              ? null
              : (newCity) async {
                  setState(() => _selectedCity = newCity);

                  if (newCity != null && _selectedCountry != null) {
                    widget.onCitySelected?.call(newCity);
                  }
                },
          items: _selectedCountry == null
              ? []
              : cities.map((city) {
                  final name = city.name[locale] ?? city.name['en'] ?? '';
                  return DropdownMenuItem(value: city, child: Text(' $name'));
                }).toList(),
        ),
      ],
    );
  }
}
