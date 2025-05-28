import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abhrna/models/user_model.dart';
import 'package:abhrna/services/firebase_auth_service.dart';
import 'package:abhrna/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  final FirestoreService<UserModel> _userService = FirestoreService<UserModel>(
    collection: 'users',
    fromMap: (map) => UserModel.fromMap(map),
    toMap: (model, {forUpdate = false}) => model.toMap(forUpdate: forUpdate),
  );

  UserModel? _userModel;
  bool _isReady = false;

  /// المستخدم الحالي
  UserModel? get user => _userModel;

  /// هل Firebase جاهزة؟
  bool get isReady => _isReady;

  /// هل المستخدم مسجل دخول؟
  bool get isLoggedIn => _userModel != null;

  /// مراقبة التغييرات في حالة المستخدم
  bool _hasStartedListening = false;

  StreamSubscription? _userSubscription;

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  void listenToUserDoc(String uid) {
    _userSubscription?.cancel(); // نلغي أي اشتراك قديم

    _userSubscription = _userService.watchById(uid).listen((userData) {
      if (userData != null) {
        _userModel = userData;
        notifyListeners(); // يحدث أي واجهة تعتمد على user
      }
    });
  }

  void listenToAuthState() {
    if (_hasStartedListening) return;
    _hasStartedListening = true;

    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      _isReady = false;
      notifyListeners();

      if (firebaseUser != null) {
        listenToUserDoc(firebaseUser.uid);
      } else {
        _userModel = null;
        _userSubscription?.cancel();
      }

      _isReady = true;
      notifyListeners();
    });
  }

  /// التحقق من حالة تسجيل الدخول
  Future<void> checkCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userModel = await _userService.getById(currentUser.uid);
    } else {
      _userModel = null;
    }
    _isReady = true;
    notifyListeners();
  }

  /// تسجيل الدخول باستخدام Google
  Future<bool> signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();
    return result != null;
  }

  /// تسجيل الدخول بالبريد
  Future<void> signInWithEmail(String email, String password) async {
    final result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    if (result != null) {
      _userModel = await _userService.getById(result.user!.uid);
      notifyListeners();
    }
  }

  /// إنشاء حساب جديد
  Future<void> registerWithEmail(String email, String password) async {
    final result = await _authService.registerWithEmail(
      email: email,
      password: password,
    );

    if (result != null) {
      _userModel = await _userService.getById(result.user!.uid);
      notifyListeners();
    }
  }

  /// تسجيل خروج
  Future<void> signOut() async {
    await _authService.signOut();
    _userModel = null;
    _userSubscription?.cancel();
    _isReady = false;
    notifyListeners();
  }
}
