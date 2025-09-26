import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveParentProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required List<Map<String, String>> children,
  }) async {
    await _db.collection('users').doc(uid).set({
      'role': 'parent',
      'name': name,
      'email': email,
      'phone': phone,
      'children': children,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveTeacherProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String className,
    required List<String> subjects,
  }) async {
    await _db.collection('users').doc(uid).set({
      'role': 'teacher',
      'name': name,
      'email': email,
      'phone': phone,
      'class': className,
      'subjects': subjects,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> toggleStarOfTheMonth({
    required String className,
    required String studentId,
    required bool isStar,
  }) async {
    await _db.collection('classes').doc(className).collection('students').doc(studentId).set({
      'starOfTheMonth': isStar,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
