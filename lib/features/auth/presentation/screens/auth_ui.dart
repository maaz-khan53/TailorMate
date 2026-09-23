// AUTH_REFERENCE_WAVE_V2
import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    super.key,
    required this.child,
    required this.visualIcon,
    this.showBackButton = false,
    this.onBack,
  });

  final Widget child;
  final IconData visualIcon;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: palette.page,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Positioned.fill(child: _SoftPageBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewport) {
                final double width = viewport.maxWidth;
                final bool desktop = width >= 980;
                final double sidePadding = desktop
                    ? 48
                    : width >= 600
                    ? 30
                    : width < 360
                    ? 12
                    : 16;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    sidePadding,
                    desktop ? 28 : 14,
                    sidePadding,
                    28 + MediaQuery.viewInsetsOf(context).bottom * .12,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: (viewport.maxHeight -
                          MediaQuery.paddingOf(context).vertical -
                          42)
                          .clamp(0.0, double.infinity)
                          .toDouble(),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(maxWidth: 1120),
                        child: desktop
                            ? Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: _LargeTailorVisual(
                                icon: visualIcon,
                              ),
                            ),
                            const SizedBox(width: 44),
                            SizedBox(
                              width: 465,
                              child: _PhoneAuthCard(
                                visualIcon: visualIcon,
                                showBackButton:
                                showBackButton,
                                onBack: onBack,
                                child: child,
                              ),
                            ),
                          ],
                        )
                            : ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 560,
                          ),
                          child: _PhoneAuthCard(
                            visualIcon: visualIcon,
                            showBackButton: showBackButton,
                            onBack: onBack,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPalette {
  const AuthPalette({
    required this.dark,
    required this.page,
    required this.surface,
    required this.field,
    required this.border,
    required this.text,
    required this.muted,
  });

  final bool dark;
  final Color page;
  final Color surface;
  final Color field;
  final Color border;
  final Color text;
  final Color muted;

  factory AuthPalette.of(BuildContext context) {
    final bool dark =
        Theme.of(context).brightness == Brightness.dark;

    return AuthPalette(
      dark: dark,
      page: dark
          ? const Color(0xFF06130F)
          : const Color(0xFFF2F7F5),
      surface:
      dark ? const Color(0xFF0C211A) : Colors.white,
      field: dark
          ? const Color(0xFF142D25)
          : const Color(0xFFF0F5F3),
      border: dark
          ? Colors.white.withValues(alpha: .08)
          : const Color(0xFFDCE8E3),
      text: dark ? Colors.white : AppColors.textPrimary,
      muted:
      dark ? Colors.white70 : AppColors.textSecondary,
    );
  }
}

class _PhoneAuthCard extends StatelessWidget {
  const _PhoneAuthCard({
    required this.visualIcon,
    required this.showBackButton,
    required this.onBack,
    required this.child,
  });

  final IconData visualIcon;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: palette.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: palette.dark ? .24 : .11,
            ),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _VisualHeader(
                icon: visualIcon,
                showBackButton: showBackButton,
                onBack: onBack,
              ),
              Transform.translate(
                offset: const Offset(0, -34),
                child: ClipPath(
                  clipper: _AuthWaveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: palette.surface,
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      62,
                      20,
                      22,
                    ),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisualHeader extends StatelessWidget {
  const _VisualHeader({
    required this.icon,
    required this.showBackButton,
    required this.onBack,
  });

  final IconData icon;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF064F43),
                  Color(0xFF08715F),
                  Color(0xFF0B927A),
                ],
              ),
            ),
          ),
          const CustomPaint(
            painter: _LeafyTailorPainter(),
          ),
          Positioned(
            right: -54,
            top: -50,
            child: _Orb(
              size: 170,
              color: Colors.white,
              opacity: .06,
            ),
          ),
          Positioned(
            left: -45,
            bottom: 30,
            child: _Orb(
              size: 128,
              color: AppColors.gold,
              opacity: .08,
            ),
          ),
          if (showBackButton)
            Positioned(
              top: 15,
              left: 15,
              child: _GlassRoundButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack ??
                        () => Navigator.of(context).maybePop(),
              ),
            ),
          Center(
            child: _TailorIllustration(icon: icon),
          ),
        ],
      ),
    );
  }
}

class _TailorIllustration extends StatelessWidget {
  const _TailorIllustration({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 176,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 106,
            height: 126,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .96),
              borderRadius: BorderRadius.circular(31),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: .18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 60,
            ),
          ),
          const Positioned(
            top: 5,
            right: 18,
            child: _ToolChip(
              icon: Icons.content_cut_rounded,
            ),
          ),
          const Positioned(
            left: 12,
            bottom: 8,
            child: _ToolChip(
              icon: Icons.straighten_rounded,
              gold: true,
            ),
          ),
          Positioned(
            right: 25,
            bottom: 18,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: .19),
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.icon,
    this.gold = false,
  });

  final IconData icon;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: gold
            ? AppColors.gold
            : Colors.white.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(14),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .12),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Icon(
        icon,
        color:
        gold ? AppColors.primaryDark : AppColors.primary,
        size: 23,
      ),
    );
  }
}

class _GlassRoundButton extends StatelessWidget {
  const _GlassRoundButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .92),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: .12),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _AuthWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, 34);

    path.cubicTo(
      size.width * .14,
      0,
      size.width * .30,
      4,
      size.width * .43,
      20,
    );

    path.cubicTo(
      size.width * .62,
      44,
      size.width * .79,
      4,
      size.width,
      25,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant _AuthWaveClipper oldClipper) =>
      false;
}

class _LargeTailorVisual extends StatelessWidget {
  const _LargeTailorVisual({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF064C40),
            Color(0xFF08715F),
            Color(0xFF0C987F),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .20),
            blurRadius: 38,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: CustomPaint(
              painter: _LeafyTailorPainter(),
            ),
          ),
          Positioned(
            right: -90,
            top: -90,
            child: _Orb(
              size: 300,
              color: Colors.white,
              opacity: .06,
            ),
          ),
          Center(
            child: Transform.scale(
              scale: 1.75,
              child: _TailorIllustration(icon: icon),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeafyTailorPainter extends CustomPainter {
  const _LeafyTailorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint leafPaint = Paint()
      ..color = Colors.white.withValues(alpha: .055);

    final Paint linePaint = Paint()
      ..color = Colors.white.withValues(alpha: .085)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    for (int i = 0; i < 6; i++) {
      final double x =
          size.width * (.05 + ((i % 3) * .36));
      final double y =
          size.height * (.10 + ((i ~/ 3) * .43));

      final Rect oval = Rect.fromCenter(
        center: Offset(x + 34, y + 34),
        width: 110,
        height: 42,
      );

      canvas.save();
      canvas.translate(
        oval.center.dx,
        oval.center.dy,
      );
      canvas.rotate((i.isEven ? -1 : 1) * .45);
      canvas.translate(
        -oval.center.dx,
        -oval.center.dy,
      );
      canvas.drawOval(oval, leafPaint);
      canvas.restore();
    }

    final Path thread = Path()
      ..moveTo(size.width * .04, size.height * .27)
      ..cubicTo(
        size.width * .25,
        size.height * .08,
        size.width * .62,
        size.height * .18,
        size.width * .94,
        size.height * .07,
      )
      ..cubicTo(
        size.width * .78,
        size.height * .48,
        size.width * .87,
        size.height * .72,
        size.width * .98,
        size.height * .86,
      );

    canvas.drawPath(thread, linePaint);
  }

  @override
  bool shouldRepaint(
      covariant _LeafyTailorPainter oldDelegate,
      ) =>
      false;
}

class _SoftPageBackground extends StatelessWidget {
  const _SoftPageBackground();

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return CustomPaint(
      painter: _SoftPagePainter(
        isDark: palette.dark,
      ),
    );
  }
}

class _SoftPagePainter extends CustomPainter {
  const _SoftPagePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint green = Paint()
      ..color = AppColors.primary.withValues(
        alpha: isDark ? .08 : .045,
      );

    final Path top = Path()
      ..moveTo(size.width * .55, 0)
      ..cubicTo(
        size.width * .72,
        size.height * .03,
        size.width * .88,
        size.height * .15,
        size.width,
        size.height * .10,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(top, green);

    final Paint gold = Paint()
      ..color = AppColors.gold.withValues(
        alpha: isDark ? .035 : .05,
      );

    final Path bottom = Path()
      ..moveTo(0, size.height * .80)
      ..cubicTo(
        size.width * .16,
        size.height * .70,
        size.width * .38,
        size.height * .90,
        size.width * .48,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(bottom, gold);
  }

  @override
  bool shouldRepaint(
      covariant _SoftPagePainter oldDelegate,
      ) =>
      oldDelegate.isDark != isDark;
}

class _Orb extends StatelessWidget {
  const _Orb({
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
        ),
      ),
    );
  }
}

class AuthSectionHeading extends StatelessWidget {
  const AuthSectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return Column(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.text,
            fontSize: 26,
            letterSpacing: -.4,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.muted,
            fontSize: 11.5,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffix,
    this.validator,
    this.autofillHints,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: TextStyle(
        color: palette.text,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: palette.muted.withValues(alpha: .72),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
          size: 19,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: palette.field,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide:
          const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.loading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:
            AppColors.primary.withValues(alpha: .22),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: loading ? null : onPressed,
          icon: loading
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.1,
              color: Colors.white,
            ),
          )
              : Icon(icon, size: 18),
          label: Text(
            loading ? 'PLEASE WAIT...' : label,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class AuthSuccessCard extends StatelessWidget {
  const AuthSuccessCard({
    super.key,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
    this.icon = Icons.verified_rounded,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AuthPalette palette = AuthPalette.of(context);

    return Column(
      children: <Widget>[
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: .11),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.success,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.text,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: palette.muted,
            fontSize: 11.5,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        AuthPrimaryButton(
          label: buttonLabel,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
