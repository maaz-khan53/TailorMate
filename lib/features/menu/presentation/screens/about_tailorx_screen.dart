import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

class AboutTailorXScreen extends StatelessWidget {
  const AboutTailorXScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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

    final double width = MediaQuery.sizeOf(context).width;
    final bool isSmallMobile = width <= 360;
    final bool isTablet = width >= 600;
    final double horizontalPadding = isSmallMobile
        ? 12
        : width < 600
        ? 16
        : width < 1024
        ? 24
        : 28;
    final double maxWidth = width >= 1100 ? 760 : isTablet ? 680 : 460;

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
                  isDark ? const Color(0xFF0A211B) : const Color(0xFFF7FCFA),
                  background,
                ],
              ),
            ),
          ),
          Positioned(
            top: -95,
            right: -70,
            child: _GlowCircle(
              size: 260,
              color: AppColors.primaryLight,
              opacity: isDark ? 0.10 : 0.07,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isTablet ? 20 : 14,
                    horizontalPadding,
                    32,
                  ),
                  children: <Widget>[
                    _TopBar(
                      title: 'About TailorX',
                      subtitle: 'App information and version',
                      onBack: () => Navigator.of(context).pop(),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 20),
                    _buildHeroCard(),
                    const SizedBox(height: 16),
                    _InfoCard(
                      surface: surface,
                      border: border,
                      title: 'About the App',
                      icon: Icons.content_cut_rounded,
                      child: Text(
                        'TailorX is a smart tailoring workspace designed to help tailors manage customers, measurements, orders, payments and daily shop work from one place.',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 10.5,
                          height: 1.55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(
                      surface: surface,
                      border: border,
                      title: 'App Details',
                      icon: Icons.info_outline_rounded,
                      child: Column(
                        children: <Widget>[
                          _DetailRow(
                            label: 'App Name',
                            value: 'TailorX',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                          Divider(color: border, height: 22),
                          _DetailRow(
                            label: 'Version',
                            value: '1.0.0',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                          Divider(color: border, height: 22),
                          _DetailRow(
                            label: 'Build',
                            value: '1',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                          Divider(color: border, height: 22),
                          _DetailRow(
                            label: 'Platform',
                            value: 'Flutter',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(
                      surface: surface,
                      border: border,
                      title: 'Core Features',
                      icon: Icons.auto_awesome_rounded,
                      child: Column(
                        children: <Widget>[
                          _FeatureRow(
                            icon: Icons.people_alt_rounded,
                            text: 'Customer management',
                            primaryText: primaryText,
                          ),
                          _FeatureRow(
                            icon: Icons.straighten_rounded,
                            text: 'Dress measurements',
                            primaryText: primaryText,
                          ),
                          _FeatureRow(
                            icon: Icons.inventory_2_rounded,
                            text: 'Order tracking',
                            primaryText: primaryText,
                          ),
                          _FeatureRow(
                            icon: Icons.payments_rounded,
                            text: 'Payment management',
                            primaryText: primaryText,
                          ),
                          _FeatureRow(
                            icon: Icons.cloud_done_rounded,
                            text: 'Backup-ready workflow',
                            primaryText: primaryText,
                            last: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: surfaceSoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        children: <Widget>[
                          _SimpleActionRow(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'Privacy information will be added here.',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                          Divider(color: border, height: 22),
                          _SimpleActionRow(
                            icon: Icons.description_outlined,
                            title: 'Terms & Conditions',
                            subtitle: 'Terms information will be added here.',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Made for Tailors',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'TailorX • Smart Tailoring Workspace',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
              ),
            ),
            child: const Icon(
              Icons.content_cut_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(height: 13),
          const Text(
            'TailorX',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Smart Tailoring Workspace',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 11),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'VERSION 1.0.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.primaryText,
    required this.secondaryText,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Builder(
          builder: (BuildContext context) {
            final bool isDark =
                Theme.of(context).brightness == Brightness.dark;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack,
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
          },
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.surface,
    required this.border,
    required this.title,
    required this.icon,
    required this.child,
  });

  final Color surface;
  final Color border;
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText =
    isDark ? AppColors.darkText : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.primaryText,
    required this.secondaryText,
  });

  final String label;
  final String value;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: primaryText,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.text,
    required this.primaryText,
    this.last = false,
  });

  final IconData icon;
  final String text;
  final Color primaryText;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 11),
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.primary, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: primaryText,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _SimpleActionRow extends StatelessWidget {
  const _SimpleActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryText,
    required this.secondaryText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: 60,
              spreadRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}
