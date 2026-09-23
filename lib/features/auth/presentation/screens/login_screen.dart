// AUTH_REFERENCE_WAVE_V2
import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import 'auth_ui.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';
import 'tailorx_splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identityController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _identityValidator(String? value) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty) return 'Enter email or phone number';

    if (input.contains('@')) {
      return input.contains('.') ? null : 'Enter a valid email';
    }

    final String digits =
    input.replaceAll(RegExp(r'[^0-9+]'), '');

    return digits.length >= 10
        ? null
        : 'Enter a valid phone number';
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // Demo login delay.
    // Replace this section later with your real API/authentication.
    await Future<void>.delayed(
      const Duration(milliseconds: 650),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    // IMPORTANT:
    // Do NOT open Dashboard directly here.
    // First show the premium TailorX post-login splash.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => const TailorXSplashScreen(),
      ),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return AuthPageShell(
      visualIcon: Icons.dry_cleaning_rounded,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const AuthSectionHeading(
              title: 'Welcome back',
              subtitle: 'Login to your account',
            ),
            const SizedBox(height: 22),
            AuthField(
              controller: _identityController,
              hint: 'Email or Phone',
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[
                AutofillHints.username,
                AutofillHints.email,
                AutofillHints.telephoneNumber,
              ],
              validator: _identityValidator,
            ),
            const SizedBox(height: 13),
            AuthField(
              controller: _passwordController,
              hint: 'Password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const <String>[
                AutofillHints.password,
              ],
              onFieldSubmitted: (_) => _login(),
              validator: (String? value) =>
              (value?.length ?? 0) < 6
                  ? 'Minimum 6 characters'
                  : null,
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: palette.muted,
                  size: 19,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _rememberMe = !_rememberMe;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.primary,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          color: palette.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                        const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AuthPrimaryButton(
              label: 'LOGIN',
              onPressed: _login,
              loading: _isLoading,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                    const CreateAccountScreen(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: palette.muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                  children: const <InlineSpan>[
                    TextSpan(
                      text: 'Don\'t have an account? ',
                    ),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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
