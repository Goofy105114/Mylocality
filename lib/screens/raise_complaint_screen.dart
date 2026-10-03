import 'package:flutter/material.dart';

import '../services/complaint_service.dart';
import '../theme/app_theme.dart';

class RaiseComplaintScreen extends StatefulWidget {
  /// Called after a successful submit (used to jump to "My Complaints").
  final VoidCallback? onSubmitted;
  const RaiseComplaintScreen({super.key, this.onSubmitted});

  @override
  State<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _desc = TextEditingController();
  final _service = ComplaintService();

  String? _category;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _desc.addListener(() => setState(() {})); // live progress cue
  }

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  double get _progress {
    if (_category != null && _desc.text.trim().length >= 10) return 1.0;
    if (_category != null || _desc.text.trim().length >= 10) return 0.5;
    if (_desc.text.trim().isNotEmpty) return 0.2;
    return 0;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _service.submitComplaint(
        category: _category!,
        description: _desc.text,
      );
      if (!mounted) return;
      _desc.clear();
      setState(() => _category = null);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('Complaint submitted. Status: Pending')));
      widget.onSubmitted?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _sectionTitle(int n, String text, bool done) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: done ? AppColors.teal : AppColors.primary,
          child: done
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text('$n',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _progress),
                    duration: const Duration(milliseconds: 350),
                    builder: (_, v, __) => LinearProgressIndicator(
                      value: v,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE5E7EB),
                      color: AppColors.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                    _progress == 1
                        ? 'All set. Ready to submit'
                        : '${(_progress * 100).round()}% complete',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 22),
                _sectionTitle(1, 'What is the issue?', _category != null),
                const SizedBox(height: 14),
                FormField<String>(
                  validator: (_) =>
                      _category == null ? 'Please select a category' : null,
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.05,
                        children: ComplaintService.categories.map((c) {
                          final m = CategoryMeta.of(c);
                          final sel = _category == c;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _category = c);
                              state.didChange(c);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: sel ? m.color : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: sel
                                        ? m.color
                                        : const Color(0xFFE5E7EB)),
                                boxShadow: sel
                                    ? [
                                        BoxShadow(
                                            color: m.color
                                                .withValues(alpha: 0.35),
                                            blurRadius: 12,
                                            offset: const Offset(0, 5))
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(m.icon,
                                      size: 28,
                                      color: sel ? Colors.white : m.color),
                                  const SizedBox(height: 6),
                                  Text(c,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: sel
                                              ? Colors.white
                                              : AppColors.ink)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(state.errorText!,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                _sectionTitle(2, 'Describe it',
                    _desc.text.trim().length >= 10),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _desc,
                  maxLines: 5,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText:
                        'e.g. Street light near Block C has been off for 3 days',
                  ),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Please describe the problem';
                    if (s.length < 10) {
                      return 'Add a bit more detail (min 10 characters)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white))
                      : const Icon(Icons.send_rounded),
                  label: Text(_loading ? 'Submitting…' : 'Submit complaint'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
