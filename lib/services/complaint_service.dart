import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/complaint.dart';

class ComplaintService {
  final _col = FirebaseFirestore.instance.collection('complaints');

  static const categories = [
    'Street Light',
    'Garbage / Waste',
    'Water Supply',
    'Road / Pothole',
    'Drainage / Sewage',
    'Noise',
    'Other',
  ];

  /// Async submit. New complaints always start as "Pending".
  Future<void> submitComplaint({
    required String category,
    required String description,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'You must be logged in.';

    await _col.add({
      'userId': user.uid,
      'userEmail': user.email,
      'category': category,
      'description': description.trim(),
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    }).timeout(const Duration(seconds: 15),
        onTimeout: () => throw 'Request timed out. Check your connection.');
  }

  /// Real-time stream of the signed-in resident's complaints (newest first).
  /// Sorted client-side so no composite Firestore index is needed.
  Stream<List<Complaint>> streamMyComplaints() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.error('You must be logged in.');

    return _col
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(Complaint.fromDoc).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }
}
