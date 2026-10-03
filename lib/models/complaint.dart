import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint {
  final String id;
  final String userId;
  final String category;
  final String description;
  final String status;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.userId,
    required this.category,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory Complaint.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'];
    return Complaint(
      id: doc.id,
      userId: d['userId'] ?? '',
      category: d['category'] ?? 'Other',
      description: d['description'] ?? '',
      status: d['status'] ?? 'Pending',
      // serverTimestamp can be null briefly right after writing
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}
