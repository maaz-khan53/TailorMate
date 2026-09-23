// LANGUAGE_COMPACT_V2
import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

/// Lightweight app-language controller.
///
/// English is the default language. The selected locale can be consumed by
/// MaterialApp later using AppLanguageController.instance.localeNotifier.
class AppLanguageController {
  AppLanguageController._();

  static final AppLanguageController instance = AppLanguageController._();

  final ValueNotifier<Locale> localeNotifier =
  ValueNotifier<Locale>(const Locale('en'));

  Locale get locale => localeNotifier.value;

  void setLanguage(String languageCode) {
    if (languageCode != 'en' && languageCode != 'ur') return;
    localeNotifier.value = Locale(languageCode);
  }
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _selectedLanguageCode;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode =
        AppLanguageController.instance.locale.languageCode;
  }

  Future<void> _saveLanguage() async {
    if (_saving) return;

    setState(() => _saving = true);

    await Future<void>.delayed(const Duration(milliseconds: 220));

    if (!mounted) return;

    AppLanguageController.instance.setLanguage(_selectedLanguageCode);

    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Text(
          _selectedLanguageCode == 'ur'
              ? 'Urdu selected successfully.'
              : 'English selected successfully.',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 600;
    final bool isSmallMobile = width <= 360;

    final Color background =
    isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final Color surface =
    isDark ? AppColors.darkSurface : AppColors.surface;
    final Color surfaceSoft =
    isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
    final Color border =
    isDark ? AppColors.darkBorder : AppColors.border;
    final Color primaryText =
    isDark ? AppColors.darkText : AppColors.textPrimary;
    final Color secondaryText =
    isDark ? AppColors.grey400 : AppColors.textSecondary;

    final double horizontalPadding = isSmallMobile
        ? 12
        : width < 600
        ? 16
        : width < 1024
        ? 24
        : 28;

    final double contentMaxWidth = width >= 1100
        ? 620
        : isTablet
        ? 560
        : 400;

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
            top: -95,
            right: -75,
            child: _LanguageGlow(
              size: 260,
              color: AppColors.primaryLight,
              opacity: isDark ? 0.11 : 0.07,
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
                    30,
                  ),
                  children: <Widget>[
                    _buildHeader(
                      context: context,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isTablet ? 22 : 18),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.22),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: isTablet ? 62 : 56,
                            height: isTablet ? 62 : 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.translate_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Choose Language',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Select the language you want to use in TailorX.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10.5,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        children: <Widget>[
                          _LanguageOption(
                            title: 'English',
                            subtitle: 'Use TailorX in English',
                            badge: 'EN',
                            selected: _selectedLanguageCode == 'en',
                            surfaceSoft: surfaceSoft,
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                            border: border,
                            onTap: () {
                              setState(() {
                                _selectedLanguageCode = 'en';
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          _LanguageOption(
                            title: 'اردو',
                            subtitle: 'TailorX کو اردو میں استعمال کریں',
                            badge: 'UR',
                            selected: _selectedLanguageCode == 'ur',
                            surfaceSoft: surfaceSoft,
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                            border: border,
                            onTap: () {
                              setState(() {
                                _selectedLanguageCode = 'ur';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.13),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'English is selected by default. You can switch to Urdu anytime from Menu > Language.',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 9.2,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _saveLanguage,
                        icon: _saving
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.check_circle_rounded),
                        label: Text(
                          _saving ? 'Saving...' : 'Save Language',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                          ),
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

  Widget _buildHeader({
    required BuildContext context,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Row(
      children: <Widget>[
        Builder(
          builder: (BuildContext navContext) {
            final bool isDark =
                Theme.of(navContext).brightness == Brightness.dark;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(15),
                child: Ink(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFFAFCFC),
                    borderRadius: BorderRadius.circular(11),
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Language',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.35,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Choose your preferred language',
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
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.selected,
    required this.surfaceSoft,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final bool selected;
  final Color surfaceSoft;
  final Color primaryText;
  final Color secondaryText;
  final Color border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.10)
                : surfaceSoft,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? AppColors.primary : border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.primaryGradient : null,
                  color: selected ? null : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 8.8,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.primary : border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageGlow extends StatelessWidget {
  const _LanguageGlow({
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
              blurRadius: 65,
              spreadRadius: 14,
            ),
          ],
        ),
      ),
    );
  }
}

