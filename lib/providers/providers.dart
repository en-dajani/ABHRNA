import 'package:abhrna/providers/boat_provider.dart';
import 'package:abhrna/providers/location_provider.dart';
import 'package:abhrna/providers/user_provider.dart';
import 'package:provider/provider.dart';

final List<ChangeNotifierProvider> appProviders = [
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
  ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
  ChangeNotifierProvider<BoatProvider>(create: (_) => BoatProvider()),
  // ChangeNotifierProvider(create: (_) => TripProvider()),
];
