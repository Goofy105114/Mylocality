import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = ComplaintStatus.color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ComplaintStatus.icon(status), size: 14, color: c),
          const SizedBox(width: 5),
          Text(status,
              style: TextStyle(
                  color: c, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}
