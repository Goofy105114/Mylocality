import 'package:flutter/material.dart';

import '../models/complaint.dart';
import '../services/complaint_service.dart';
import '../theme/app_theme.dart';
import '../widgets/complaint_card.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final _service = ComplaintService();
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Complaint>>(
      stream: _service.streamMyComplaints(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return _message(
            Icons.cloud_off_rounded,
            'Could not load complaints.\n${snap.error}',
          );
        }

        final all = snap.data ?? [];
        final items = _filter == 'All'
            ? all
            : all.where((c) => c.status == _filter).toList();

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                _stats(all),
                Expanded(
                  child: items.isEmpty
                      ? _message(
                          Icons.inbox_rounded,
                          all.isEmpty
                              ? 'No complaints yet.\nRaise your first one from the Raise tab.'
                              : 'No $_filter complaints.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: items.length,
                          itemBuilder: (_, i) =>
                              ComplaintCard(complaint: items[i]),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Tappable summary tiles that also act as filters.
  Widget _stats(List<Complaint> all) {
    int count(String s) => all.where((c) => c.status == s).length;
    final tiles = <(String, int, Color)>[
      ('All', all.length, AppColors.primary),
      (ComplaintStatus.pending, count(ComplaintStatus.pending),
          ComplaintStatus.color(ComplaintStatus.pending)),
      (ComplaintStatus.inProgress, count(ComplaintStatus.inProgress),
          ComplaintStatus.color(ComplaintStatus.inProgress)),
      (ComplaintStatus.resolved, count(ComplaintStatus.resolved),
          ComplaintStatus.color(ComplaintStatus.resolved)),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: tiles.map((t) {
          final sel = _filter == t.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filter = t.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? t.$3 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: sel
                      ? [
                          BoxShadow(
                            color: t.$3.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          )
                        ]
                      : AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    Text(
                      '${t.$2}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: sel ? Colors.white : t.$3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _message(IconData icon, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: AppColors.primary.withValues(alpha: 0.35)),
            const SizedBox(height: 14),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15, height: 1.5, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
