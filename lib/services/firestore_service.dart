import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:abhrna/helpers/firebase_errors.dart';

class FirestoreService<T> {
  final String collection;
  final T Function(Map<String, dynamic> map) fromMap;
  final Map<String, dynamic> Function(T model, {bool forUpdate}) toMap;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService({
    required this.collection,
    required this.fromMap,
    required this.toMap,
  });

  /// توليد ID تلقائي من السيرفر
  String generateId() {
    return _firestore.collection(collection).doc().id;
  }

  /// إضافة مستند جديد
  Future<void> add(T data) async {
    try {
      final map = toMap(data, forUpdate: false);
      final id = map['id'];
      if (id == null || id is! String || id.isEmpty) {
        throw 'Missing or invalid document ID';
      }
      await _firestore.collection(collection).doc(id).set(map);
    } on FirebaseException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// تحديث مستند موجود
  Future<void> update(T data) async {
    try {
      final map = toMap(data, forUpdate: true);
      final id = map['id'];
      if (id == null || id is! String || id.isEmpty) {
        throw 'Missing or invalid document ID';
      }
      await _firestore.collection(collection).doc(id).update(map);
    } on FirebaseException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// حذف مستند
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// جلب مستند بالـ ID
  Future<T?> getById(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return fromMap(data);
      }
      return null;
    } on FirebaseException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// جلب مجموعة مستندات مع دعم الفلاتر والـ pagination
  Future<(List<T> data, DocumentSnapshot? lastDoc)> queryCollection({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      filters?.forEach((field, value) {
        query = query.where(field, isEqualTo: value);
      });

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      final data =
          snapshot.docs.map((doc) {
            final map = doc.data() as Map<String, dynamic>;
            map['id'] = doc.id;
            return fromMap(map);
          }).toList();
      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      return (data, lastDoc);
    } on FirebaseException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// بث حي لمجموعة مستندات (بدون دعم pagination)
  Stream<List<T>> watchCollection({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);

    filters?.forEach((field, value) {
      query = query.where(field, isEqualTo: value);
    });

    if (orderBy != null) query = query.orderBy(orderBy, descending: descending);
    if (limit != null) query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        map['id'] = doc.id;
        return fromMap(map);
      }).toList();
    });
  }

  /// بث حي لمستند واحد
  Stream<T?> watchById(String id) {
    return _firestore.collection(collection).doc(id).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return fromMap(data);
      }
      return null;
    });
  }

  /// جلب آخر مستند بحسب ترتيب معين (اختياري - مفيد للـ pagination الخارجي)
  Future<DocumentSnapshot?> getLastDocument({
    required String orderBy,
    bool descending = false,
  }) async {
    try {
      final snapshot =
          await _firestore
              .collection(collection)
              .orderBy(orderBy, descending: descending)
              .limit(1)
              .get();

      return snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
    } on FirebaseException catch (e) {
      throw FirebaseErrors.getMessage(e.code);
    } catch (_) {
      throw FirebaseErrors.getMessage('unexpected');
    }
  }

  /// بث حي للعدّ (مثلاً عدد التنبيهات غير المقروءة)
  Stream<int> watchCount({required Map<String, dynamic> filters}) {
    Query query = _firestore.collection(collection);
    filters.forEach((field, value) {
      query = query.where(field, isEqualTo: value);
    });
    return query.snapshots().map((snapshot) => snapshot.docs.length);
  }
}
