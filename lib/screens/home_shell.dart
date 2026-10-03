import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'my_complaints_screen.dart';
import 'raise_complaint_screen.dart';

/// Gradient header + bottom navigation: Raise | My Complaints
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _auth = AuthService();

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to track complaints.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(90, 42)),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log out')),
        ],
      ),
    );
    if (ok == true) await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final name = (user?.displayName?.trim().isNotEmpty == true)
        ? user!.displayName!
        : (user?.email ?? 'resident').split('@').first;
    final titles = ['Raise a complaint', 'My complaints'];

    final body = _index == 0
        ? RaiseComplaintScreen(
            key: const ValueKey('raise'),
            onSubmitted: () => setState(() => _index = 1))
        : const MyComplaintsScreen(key: ValueKey('mine'));

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, $name 👋',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(titles[_index],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Log out',
                      icon: const Icon(Icons.logout_rounded,
                          color: Colors.white),
                      onPressed: _confirmLogout,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: body,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.add_circle_outline_rounded),
              selectedIcon:
                  Icon(Icons.add_circle_rounded, color: AppColors.primary),
              label: 'Raise'),
          NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon:
                  Icon(Icons.assignment_rounded, color: AppColors.primary),
              label: 'My complaints'),
        ],
      ),
    );
  }
}
