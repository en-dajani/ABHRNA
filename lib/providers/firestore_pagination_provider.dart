import 'package:abhrna/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestorePaginationProvider<T> extends ChangeNotifier {
  final FirestoreService<T> service;

  List<T> items = [];
  DocumentSnapshot? lastDoc;
  bool isLoading = false;
  bool hasMore = true;

  FirestorePaginationProvider({required this.service});

  Future<void> loadInitial({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int limit = 100,
  }) async {
    _reset();
    isLoading = true;
    notifyListeners();

    try {
      final (data, doc) = await service.queryCollection(
        filters: filters,
        orderBy: orderBy,
        descending: descending,
        limit: limit,
      );

      items = data;
      lastDoc = doc;
      hasMore = data.length == limit;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int limit = 20,
  }) async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final (data, doc) = await service.queryCollection(
        filters: filters,
        orderBy: orderBy,
        descending: descending,
        limit: limit,
        startAfter: lastDoc,
      );

      items.addAll(data);
      lastDoc = doc;
      hasMore = data.length == limit;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool descending = false,
    int limit = 20,
  }) async {
    await loadInitial(
      filters: filters,
      orderBy: orderBy,
      descending: descending,
      limit: limit,
    );
  }

  Future<void> add(T item) async {
    await service.add(item);
    items.insert(0, item);
    notifyListeners();
  }

  Future<void> update(T item) async {
    await service.update(item);
    final id = service.toMap(item)['id'];
    final index = items.indexWhere((e) => service.toMap(e)['id'] == id);
    if (index != -1) {
      items[index] = item;
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    await service.delete(id);
    items.removeWhere((e) => service.toMap(e)['id'] == id);
    notifyListeners();
  }

  void _reset() {
    items.clear();
    lastDoc = null;
    hasMore = true;
  }
}
