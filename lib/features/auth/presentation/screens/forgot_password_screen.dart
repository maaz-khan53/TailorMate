// AUTH_REFERENCE_WAVE_V2
import 'package:flutter/material.dart';

import 'auth_ui.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identityController =
  TextEditingController();

  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() {
    _identityController.dispose();
    super.dispose();
  }

  String? _identityValidator(String? value) {
    final String input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Enter email or phone number';
    }

    if (input.contains('@')) {
      return input.contains('.')
          ? null
          : 'Enter a valid email';
    }

    final String digits =
    input.replaceAll(RegExp(r'[^0-9+]'), '');

    return digits.length >= 10
        ? null
        : 'Enter a valid phone number';
  }

  Future<void> _sendRecovery() async {
    FocusScope.of(context).unfocus();

    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      visualIcon: Icons.key_rounded,
      showBackButton: true,
      onBack: () => Navigator.of(context).pop(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _sent
            ? AuthSuccessCard(
          key: const ValueKey<String>('sent'),
          title: 'Recovery sent',
          message:
          'If the account exists, recovery instructions will be sent to your email or phone.',
          buttonLabel: 'BACK TO LOGIN',
          icon: Icons.mark_email_read_rounded,
          onPressed: () =>
              Navigator.of(context).pop(),
        )
            : Form(
          key: _formKey,
          child: Column(
            key: const ValueKey<String>('form'),
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: <Widget>[
              const AuthSectionHeading(
                title: 'Forgot password?',
                subtitle:
                'Use your registered email or phone',
              ),
              const SizedBox(height: 20),
              AuthField(
                controller: _identityController,
                hint: 'Email or Phone',
                icon:
                Icons.alternate_email_rounded,
                keyboardType:
                TextInputType.emailAddress,
                textInputAction:
                TextInputAction.done,
                autofillHints: const <String>[
                  AutofillHints.username,
                  AutofillHints.email,
                  AutofillHints.telephoneNumber,
                ],
                validator: _identityValidator,
                onFieldSubmitted: (_) =>
                    _sendRecovery(),
              ),
              const SizedBox(height: 18),
              AuthPrimaryButton(
                label: 'SEND RECOVERY',
                onPressed: _sendRecovery,
                loading: _isLoading,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
