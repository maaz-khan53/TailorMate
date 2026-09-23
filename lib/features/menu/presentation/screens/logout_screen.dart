import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/features/auth/presentation/screens/login_screen.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({
    super.key,
    this.userName = 'Azeem Khan',
  });

  final String userName;

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  bool _loggingOut = false;

  Future<void> _logout() async {
    if (_loggingOut) return;

    setState(() => _loggingOut = true);

    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => const LoginScreen(),
      ),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.sizeOf(context);
    final bool compact = size.width < 420;

    final Color background =
    isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final Color surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final Color surfaceSoft =
    isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
    final Color border = isDark ? AppColors.darkBorder : AppColors.border;
    final Color primaryText =
    isDark ? AppColors.darkText : AppColors.textPrimary;
    final Color secondaryText =
    isDark ? AppColors.grey400 : AppColors.textSecondary;

    final double horizontalPadding = size.width < 360
        ? 12
        : size.width < 600
        ? 18
        : 28;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  background,
                  isDark ? const Color(0xFF0A211B) : const Color(0xFFF8FCFA),
                  background,
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -70,
            child: _GlowCircle(
              size: 260,
              color: AppColors.error,
              opacity: isDark ? 0.08 : 0.05,
            ),
          ),
          Positioned(
            bottom: -125,
            left: -90,
            child: _GlowCircle(
              size: 290,
              color: AppColors.primary,
              opacity: isDark ? 0.07 : 0.045,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _BackButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: primaryText,
                                    fontSize: compact ? 22 : 25,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Securely leave your TailorX account',
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: compact ? 9.5 : 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 26 : 34),
                      Container(
                        padding: EdgeInsets.all(compact ? 20 : 28),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(compact ? 24 : 30),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.20),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.12 : 0.045,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 11),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: compact ? 84 : 96,
                              height: compact ? 84 : 96,
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.10),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                  AppColors.error.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: AppColors.error,
                                size: compact ? 39 : 45,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'Logout from TailorX?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: primaryText,
                                fontSize: compact ? 21 : 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              'You are currently signed in as ${widget.userName}.\nAre you sure you want to logout?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: compact ? 11 : 12,
                                height: 1.55,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: surfaceSoft,
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(color: border),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.shield_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 11),
                                  Expanded(
                                    child: Text(
                                      'Your saved customer and order data will remain safe on this device.',
                                      style: TextStyle(
                                        color: secondaryText,
                                        fontSize: 9.5,
                                        height: 1.4,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (compact) ...<Widget>[
                              _StayButton(
                                onPressed: _loggingOut
                                    ? null
                                    : () => Navigator.of(context).pop(),
                              ),
                              const SizedBox(height: 11),
                              _LogoutButton(
                                loading: _loggingOut,
                                onPressed: _logout,
                              ),
                            ] else
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: _StayButton(
                                      onPressed: _loggingOut
                                          ? null
                                          : () => Navigator.of(context).pop(),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _LogoutButton(
                                      loading: _loggingOut,
                                      onPressed: _logout,
                                    ),
                                  ),
                                ],
                              ),
                          ],
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

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface
                : const Color(0xFFFAFCFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder
                  : const Color(0xFFD5E4E2),
              width: 1.2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.18 : 0.06,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
            size: 29,
          ),
        ),
      ),
    );
  }
}

class _StayButton extends StatelessWidget {
  const _StayButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text('Stay Logged In'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.34),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.logout_rounded),
        label: Text(loading ? 'Logging out...' : 'Logout'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.error.withValues(alpha: 0.68),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: opacity),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: 65,
              spreadRadius: 14,
            ),
          ],
        ),
      ),
    );
  }
}
