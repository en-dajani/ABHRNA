import 'package:abhrna/providers/location_provider.dart';
import 'package:abhrna/providers/user_provider.dart';
import 'package:abhrna/screens/home_screen.dart';
import 'package:abhrna/screens/welcome_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<User?>? _initFuture; // ✅ تخليها nullable

  @override
  void initState() {
    super.initState();

    // نأجل التنفيذ لبعد أول فريم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _initFuture = initApp();
      });
    });
  }

  Future<User?> initApp() async {
    try {
      final userProvider = context.read<UserProvider>();
      final locationProvider = context.read<LocationProvider>();

      await locationProvider.loadLocation(locale: context.locale.languageCode);
      userProvider.listenToAuthState();

      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ تأكد إن الـ Future جاهز قبل عرضه
    if (_initFuture == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: FutureBuilder<User?>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
