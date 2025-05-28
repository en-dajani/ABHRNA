// 📁 user_auth_firestore.dart

import 'package:abhrna/helpers/firebase_errors.dart';
import 'package:abhrna/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// خدمة المصادقة للمستخدمين باستخدام Firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// المستخدم الحالي (من Firebase)
  Future<User?> get currentUser async => _auth.currentUser;

  /// تسجيل الدخول باستخدام Google
  ///
  /// ترجع [UserCredential] إذا نجح التسجيل أو null إذا تم الإلغاء
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // فتح نافذة تسجيل الدخول بجوجل
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // المستخدم ضغط "إلغاء"

      final googleAuth = await googleUser.authentication;

      // إنشاء credential لمصادقة Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // حفظ بيانات المستخدم في Firestore إذا كان جديد
      await _saveUserToFirestore(userCredential.user, 'google');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// تسجيل الدخول باستخدام البريد وكلمة المرور
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserToFirestore(userCredential.user, 'email');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (e) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// إنشاء حساب جديد باستخدام البريد وكلمة المرور
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserToFirestore(userCredential.user, 'email');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// حفظ بيانات المستخدم الجديد في Firestore (مرة وحدة فقط)
  Future<void> _saveUserToFirestore(User? user, String? provider) async {
    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'provider': provider ?? 'unknown',
        'hasBoat': false,
        'createdAt': FieldValue.serverTimestamp(), // توقيت من الخادم
      });
    }
  }

  /// جلب بيانات المستخدم من Firestore وتحويلها لـ UserModel
  Future<UserModel?> getUserModel(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  /// تسجيل خروج من Firebase وجوجل (إن وجد)
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut(); // عشان يقفل جلسة Google
  }
}
