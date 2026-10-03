import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Submitted -> In Progress -> Resolved progress cue.
class StatusTracker extends StatelessWidget {
  final String status;
  const StatusTracker({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final step = ComplaintStatus.step(status);
    final color = ComplaintStatus.color(status);
    const labels = ['Submitted', 'In Progress', 'Resolved'];

    Widget dot(int i) {
      final done = i <= step;
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? color : Colors.white,
          border: Border.all(
              color: done ? color : const Color(0xFFD1D5DB), width: 2),
        ),
        child: done
            ? const Icon(Icons.check, size: 11, color: Colors.white)
            : null,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              dot(i),
              if (i < 2)
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: i < step ? color : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 3; i++)
              Text(labels[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: i == step ? FontWeight.w700 : FontWeight.w500,
                    color: i <= step ? AppColors.ink : AppColors.muted,
                  )),
          ],
        ),
      ],
    );
  }
}
