import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/features/menu/presentation/screens/language_screen.dart';
import 'package:tailorx/features/menu/presentation/screens/profile_screen.dart';
import 'package:tailorx/features/menu/presentation/screens/backup_restore_screen.dart';
import 'package:tailorx/features/menu/presentation/screens/about_tailorx_screen.dart';
import 'package:tailorx/features/menu/presentation/screens/logout_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    this.userName = 'Azeem Khan',
    this.businessName = 'TailorX Workspace',
  });

  final String userName;
  final String businessName;

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color background = isDark
        ? AppColors.darkScaffold
        : AppColors.scaffold;

    final Color surface = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final Color surfaceSoft = isDark
        ? AppColors.darkSurfaceSoft
        : AppColors.surfaceSoft;

    final Color border = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final Color primaryText = isDark
        ? AppColors.darkText
        : AppColors.textPrimary;

    final Color secondaryText = isDark
        ? AppColors.grey400
        : AppColors.textSecondary;

    final double width = MediaQuery.sizeOf(context).width;
    final bool isSmallMobile = width <= 360;
    final bool isTablet = width >= 600;
    final double contentMaxWidth = width >= 1100
        ? 720
        : isTablet
        ? 640
        : 430;
    final double horizontalPadding = isSmallMobile
        ? 12
        : width < 600
        ? 16
        : width < 1024
        ? 24
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
                  isDark
                      ? const Color(0xFF0A211B)
                      : const Color(0xFFF8FCFA),
                  background,
                ],
              ),
            ),
          ),
          Positioned(
            top: -90,
            right: -70,
            child: _GlowCircle(
              size: 250,
              color: AppColors.primaryLight,
              opacity: isDark ? 0.12 : 0.08,
            ),
          ),
          Positioned(
            bottom: -120,
            left: -90,
            child: _GlowCircle(
              size: 280,
              color: AppColors.primary,
              opacity: isDark ? 0.08 : 0.05,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isTablet ? 20 : 14,
                    horizontalPadding,
                    isTablet ? 36 : 28,
                  ),
                  children: <Widget>[
                    _buildTopBar(
                      context: context,
                      surface: surface,
                      border: border,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 18),
                    _buildProfileCard(
                      isDark: isDark,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 18),
                    _buildMenuGroup(
                      context: context,
                      surface: surface,
                      border: border,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      items: const <_MenuItemData>[
                        _MenuItemData(
                          title: 'My Profile',
                          subtitle: 'View and manage your profile',
                          icon: Icons.person_rounded,
                        ),
                        _MenuItemData(
                          title: 'Backup & Restore',
                          subtitle: 'Keep your customer data safe',
                          icon: Icons.cloud_done_rounded,
                        ),
                        _MenuItemData(
                          title: 'Language',
                          subtitle: 'Choose your preferred language',
                          icon: Icons.language_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildMenuGroup(
                      context: context,
                      surface: surface,
                      border: border,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      items: const <_MenuItemData>[
                        _MenuItemData(
                          title: 'About TailorX',
                          subtitle: 'App information and version',
                          icon: Icons.info_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildLogoutCard(
                      context: context,
                      surface: surface,
                      border: border,
                      primaryText: primaryText,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'TailorX • Smart Tailoring Workspace',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
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

  Widget _buildTopBar({
    required BuildContext context,
    required Color surface,
    required Color border,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Row(
      children: <Widget>[
        _PressScale(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: border,
                width: 1.2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.18
                        : 0.06,
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Menu',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.35,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Manage your TailorX experience',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard({
    required bool isDark,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 26,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -45,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'TAILOR PROFILE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 8,
                        letterSpacing: 0.9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      businessName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup({
    required BuildContext context,
    required Color surface,
    required Color border,
    required Color primaryText,
    required Color secondaryText,
    required List<_MenuItemData> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: List<Widget>.generate(
          items.length,
              (int index) {
            return Column(
              children: <Widget>[
                _MenuTile(
                  item: items[index],
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  onTap: () {
                    if (items[index].title == 'My Profile') {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ProfileScreen(
                            initialName: userName,
                            initialBusinessName: businessName,
                          ),
                        ),
                      );
                      return;
                    }

                    if (items[index].title == 'Language') {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LanguageScreen(),
                        ),
                      );
                      return;
                    }

                    if (items[index].title == 'Backup & Restore') {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const BackupRestoreScreen(),
                        ),
                      );
                      return;
                    }

                    if (items[index].title == 'About TailorX') {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AboutTailorXScreen(),
                        ),
                      );
                    }
                  },
                ),
                if (index != items.length - 1)
                  Divider(
                    height: 1,
                    indent: 68,
                    endIndent: 14,
                    color: border,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoutCard({
    required BuildContext context,
    required Color surface,
    required Color border,
    required Color primaryText,
  }) {
    return _PressScale(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => LogoutScreen(userName: userName),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.error,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.item,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  final _MenuItemData item;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                item.icon,
                color: AppColors.primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: secondaryText,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}

class _PressScale extends StatefulWidget {
  const _PressScale({
    required this.onTap,
    required this.child,
    required this.borderRadius,
  });

  final VoidCallback onTap;
  final Widget child;
  final BorderRadius borderRadius;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 110),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) => _setPressed(false),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            borderRadius: widget.borderRadius,
            child: widget.child,
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

class _MenuItemData {
  const _MenuItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
