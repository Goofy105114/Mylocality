import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF4F46E5); // indigo
  static const violet = Color(0xFF7C3AED);
  static const teal = Color(0xFF14B8A6);
  static const ink = Color(0xFF1E1B4B);
  static const muted = Color(0xFF6B7280);
  static const bg = Color(0xFFF5F6FB);
  static const field = Color(0xFFF1F2F9);

  static const gradient = LinearGradient(
    colors: [primary, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF1E1B4B).withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

/// Complaint status values stored in Firestore.
class ComplaintStatus {
  static const pending = 'Pending';
  static const inProgress = 'In Progress';
  static const resolved = 'Resolved';
  static const all = [pending, inProgress, resolved];

  static Color color(String status) {
    switch (status) {
      case inProgress:
        return const Color(0xFF2563EB); // blue
      case resolved:
        return const Color(0xFF059669); // green
      case pending:
      default:
        return const Color(0xFFF59E0B); // amber
    }
  }

  static IconData icon(String status) {
    switch (status) {
      case inProgress:
        return Icons.autorenew_rounded;
      case resolved:
        return Icons.check_circle_rounded;
      case pending:
      default:
        return Icons.schedule_rounded;
    }
  }

  /// 0 = submitted, 1 = in progress, 2 = resolved
  static int step(String status) {
    switch (status) {
      case inProgress:
        return 1;
      case resolved:
        return 2;
      default:
        return 0;
    }
  }
}

/// Icon + colour for every complaint category.
class CategoryMeta {
  final IconData icon;
  final Color color;
  const CategoryMeta(this.icon, this.color);

  static CategoryMeta of(String category) {
    switch (category) {
      case 'Street Light':
        return const CategoryMeta(Icons.lightbulb_rounded, Color(0xFFF59E0B));
      case 'Garbage / Waste':
        return const CategoryMeta(Icons.delete_rounded, Color(0xFF10B981));
      case 'Water Supply':
        return const CategoryMeta(Icons.water_drop_rounded, Color(0xFF0EA5E9));
      case 'Road / Pothole':
        return const CategoryMeta(Icons.add_road_rounded, Color(0xFF6366F1));
      case 'Drainage / Sewage':
        return const CategoryMeta(Icons.plumbing_rounded, Color(0xFF14B8A6));
      case 'Noise':
        return const CategoryMeta(Icons.volume_up_rounded, Color(0xFFEC4899));
      default:
        return const CategoryMeta(Icons.more_horiz_rounded, Color(0xFF64748B));
    }
  }
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(primary: AppColors.primary, surface: Colors.white);

    OutlineInputBorder border([Color? c, double w = 0]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: c == null ? BorderSide.none : BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bg,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(AppColors.primary, 1.6),
        errorBorder: border(Colors.redAccent, 1.2),
        focusedErrorBorder: border(Colors.redAccent, 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        height: 68,
        indicatorColor: AppColors.primary.withValues(alpha: 0.14),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
