// AUTH_REFERENCE_WAVE_V2
import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

import 'auth_ui.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController();
  final TextEditingController _phoneController =
  TextEditingController();
  final TextEditingController _emailController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _accountCreated = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _phoneValidator(String? value) {
    final String input = value?.trim() ?? '';
    final String digits =
    input.replaceAll(RegExp(r'[^0-9+]'), '');

    return digits.length >= 10
        ? null
        : 'Enter a valid phone number';
  }

  String? _emailValidator(String? value) {
    final String email = value?.trim() ?? '';
    if (email.isEmpty) return null;

    return email.contains('@') && email.contains('.')
        ? null
        : 'Enter a valid email or leave it empty';
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.warning,
          content: const Text(
            'Please accept Terms and Privacy Policy.',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future<void>.delayed(
      const Duration(milliseconds: 850),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _accountCreated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return AuthPageShell(
      visualIcon: Icons.dry_cleaning_rounded,
      showBackButton: true,
      onBack: () => Navigator.of(context).pop(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _accountCreated
            ? AuthSuccessCard(
          key: const ValueKey<String>('success'),
          title: 'Account created',
          message:
          'Your account is ready. Return to login to continue.',
          buttonLabel: 'BACK TO LOGIN',
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
                title: 'Register',
                subtitle: 'Create your new account',
              ),
              const SizedBox(height: 20),
              AuthField(
                controller: _nameController,
                hint: 'Full Name',
                icon: Icons.person_outline_rounded,
                textInputAction:
                TextInputAction.next,
                autofillHints: const <String>[
                  AutofillHints.name,
                ],
                validator: (String? value) =>
                (value?.trim().length ?? 0) < 2
                    ? 'Enter your full name'
                    : null,
              ),
              const SizedBox(height: 12),
              AuthField(
                controller: _phoneController,
                hint: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction:
                TextInputAction.next,
                autofillHints: const <String>[
                  AutofillHints.telephoneNumber,
                ],
                validator: _phoneValidator,
              ),
              const SizedBox(height: 12),
              AuthField(
                controller: _emailController,
                hint: 'Email Address (Optional)',
                icon: Icons.mail_outline_rounded,
                keyboardType:
                TextInputType.emailAddress,
                textInputAction:
                TextInputAction.next,
                autofillHints: const <String>[
                  AutofillHints.email,
                ],
                validator: _emailValidator,
              ),
              const SizedBox(height: 12),
              AuthField(
                controller: _passwordController,
                hint: 'Password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                textInputAction:
                TextInputAction.next,
                autofillHints: const <String>[
                  AutofillHints.newPassword,
                ],
                validator: (String? value) =>
                (value?.length ?? 0) < 6
                    ? 'Minimum 6 characters'
                    : null,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword =
                      !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons
                        .visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: palette.muted,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AuthField(
                controller:
                _confirmPasswordController,
                hint: 'Confirm Password',
                icon:
                Icons.verified_user_outlined,
                obscureText:
                _obscureConfirmPassword,
                textInputAction:
                TextInputAction.done,
                autofillHints: const <String>[
                  AutofillHints.newPassword,
                ],
                onFieldSubmitted: (_) =>
                    _createAccount(),
                validator: (String? value) =>
                value != _passwordController.text
                    ? 'Passwords do not match'
                    : null,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword =
                      !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons
                        .visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: palette.muted,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                borderRadius:
                BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    _acceptTerms = !_acceptTerms;
                  });
                },
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: _acceptTerms,
                      activeColor:
                      AppColors.primary,
                      visualDensity:
                      VisualDensity.compact,
                      materialTapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5),
                      ),
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptTerms =
                              value ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 7,
                        ),
                        child: Text(
                          'By signing up you agree to the Terms of Service and Privacy Policy.',
                          style: TextStyle(
                            color: palette.muted,
                            fontSize: 9.5,
                            height: 1.4,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              AuthPrimaryButton(
                label: 'SIGN UP',
                icon:
                Icons.person_add_alt_1_rounded,
                onPressed: _createAccount,
                loading: _isLoading,
              ),
              const SizedBox(height: 11),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                    children: const <InlineSpan>[
                      TextSpan(
                        text:
                        'Already have an account? ',
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),
                    ],
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
