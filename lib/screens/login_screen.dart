import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _auth = AuthService();

  bool _isLogin = true;
  bool _loading = false;
  bool _hidePass = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await _auth.signIn(_email.text, _password.text);
      } else {
        await _auth.register(_email.text, _password.text, _name.text.trim());
      }
      // AuthGate in main.dart switches screens automatically.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 340,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_city_rounded,
                            size: 42, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      const Text('MyLocality',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('Raise it. Track it. Get it fixed.',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 15)),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: AppColors.softShadow,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SegmentedButton<bool>(
                                expandedInsets: EdgeInsets.zero,
                                showSelectedIcon: false,
                                segments: const [
                                  ButtonSegment(
                                      value: true, label: Text('Log in')),
                                  ButtonSegment(
                                      value: false, label: Text('Sign up')),
                                ],
                                selected: {_isLogin},
                                onSelectionChanged: _loading
                                    ? null
                                    : (s) => setState(() => _isLogin = s.first),
                              ),
                              const SizedBox(height: 22),
                              // Name field — only shown during sign-up
                              if (!_isLogin) ...[
                                TextFormField(
                                  controller: _name,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    hintText: 'Full name',
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded),
                                  ),
                                  validator: (v) {
                                    if (!_isLogin &&
                                        (v == null || v.trim().isEmpty)) {
                                      return 'Enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                              ],
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Email address',
                                  prefixIcon: Icon(Icons.mail_outline_rounded),
                                ),
                                validator: (v) {
                                  final s = v?.trim() ?? '';
                                  if (s.isEmpty) return 'Enter your email';
                                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                      .hasMatch(s)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _password,
                                obscureText: _hidePass,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) =>
                                    _loading ? null : _submit(),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(_hidePass
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () =>
                                        setState(() => _hidePass = !_hidePass),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Enter your password';
                                  }
                                  if (!_isLogin && v.length < 6) {
                                    return 'Minimum 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              FilledButton(
                                onPressed: _loading ? null : _submit,
                                child: _loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white))
                                    : Text(_isLogin
                                        ? 'Log in'
                                        : 'Create account'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
