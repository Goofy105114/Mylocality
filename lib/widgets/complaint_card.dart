import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/complaint.dart';
import '../theme/app_theme.dart';
import 'status_chip.dart';
import 'status_tracker.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  const ComplaintCard({super.key, required this.complaint});

  String _when(DateTime d) {
    final diff = DateTime.now().difference(d);
    String rel;
    if (diff.inMinutes < 1) {
      rel = 'Just now';
    } else if (diff.inMinutes < 60) {
      rel = '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      rel = '${diff.inHours} h ago';
    } else if (diff.inDays < 7) {
      rel = '${diff.inDays} d ago';
    } else {
      rel = DateFormat('dd MMM').format(d);
    }
    return '${DateFormat('dd MMM yyyy').format(d)}  ·  $rel';
  }

  @override
  Widget build(BuildContext context) {
    final meta = CategoryMeta.of(complaint.category);
    final accent = ComplaintStatus.color(complaint.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: meta.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(meta.icon, color: meta.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(complaint.category,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink)),
                              const SizedBox(height: 2),
                              Text(_when(complaint.createdAt),
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        StatusChip(status: complaint.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(complaint.description,
                        style: const TextStyle(
                            fontSize: 14, height: 1.4, color: Color(0xFF374151))),
                    const SizedBox(height: 16),
                    StatusTracker(status: complaint.status),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
