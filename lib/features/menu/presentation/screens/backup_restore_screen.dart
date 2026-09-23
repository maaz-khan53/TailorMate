import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  bool _creatingBackup = false;
  bool _restoringBackup = false;
  DateTime? _lastBackup;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _background =>
      _isDark ? AppColors.darkScaffold : AppColors.scaffold;
  Color get _surface => _isDark ? AppColors.darkSurface : AppColors.surface;
  Color get _surfaceSoft =>
      _isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
  Color get _border => _isDark ? AppColors.darkBorder : AppColors.border;
  Color get _primaryText =>
      _isDark ? AppColors.darkText : AppColors.textPrimary;
  Color get _secondaryText =>
      _isDark ? AppColors.grey400 : AppColors.textSecondary;

  String _formatDateTime(DateTime value) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final int hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final String minute = value.minute.toString().padLeft(2, '0');
    final String period = value.hour >= 12 ? 'PM' : 'AM';
    return '${value.day} ${months[value.month - 1]} ${value.year} • $hour:$minute $period';
  }

  Future<void> _createBackup() async {
    if (_creatingBackup || _restoringBackup) return;

    setState(() => _creatingBackup = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    setState(() {
      _creatingBackup = false;
      _lastBackup = DateTime.now();
    });

    _showMessage('Backup UI completed. Connect your database export here.');
  }

  Future<void> _restoreBackup() async {
    if (_creatingBackup || _restoringBackup) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Restore Backup?'),
          content: const Text(
            'Restoring may replace current customer, measurement and order data. Continue?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _restoringBackup = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => _restoringBackup = false);
    _showMessage('Restore UI completed. Connect your backup source here.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: _background,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  _background,
                  _isDark ? const Color(0xFF0A211B) : const Color(0xFFF7FCFA),
                  _background,
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
              opacity: _isDark ? 0.10 : 0.07,
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
                      title: 'Backup & Restore',
                      subtitle: 'Keep your TailorX data safe',
                      onBack: () => Navigator.of(context).pop(),
                      primaryText: _primaryText,
                      secondaryText: _secondaryText,
                    ),
                    const SizedBox(height: 20),
                    _buildHeroCard(),
                    const SizedBox(height: 16),
                    _buildBackupStatusCard(),
                    const SizedBox(height: 14),
                    _buildDataIncludedCard(),
                    const SizedBox(height: 14),
                    _buildActionCard(
                      icon: Icons.cloud_upload_rounded,
                      title: 'Create Backup',
                      subtitle:
                      'Prepare a fresh backup of customers, measurements and orders.',
                      buttonText: _creatingBackup ? 'Creating...' : 'Create Backup',
                      loading: _creatingBackup,
                      onPressed: _createBackup,
                    ),
                    const SizedBox(height: 14),
                    _buildActionCard(
                      icon: Icons.settings_backup_restore_rounded,
                      title: 'Restore Backup',
                      subtitle:
                      'Restore your TailorX data from a previously saved backup.',
                      buttonText: _restoringBackup ? 'Restoring...' : 'Restore Backup',
                      loading: _restoringBackup,
                      outlined: true,
                      onPressed: _restoreBackup,
                    ),
                    const SizedBox(height: 14),
                    _buildInfoCard(),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 11),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.cloud_done_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your Data Matters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Keep a safe copy of your tailoring workspace and restore it when needed.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.5,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupStatusCard() {
    final bool hasBackup = _lastBackup != null;
    return _CardShell(
      surface: _surface,
      border: _border,
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (hasBackup ? AppColors.success : AppColors.primary)
                  .withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              hasBackup ? Icons.verified_rounded : Icons.history_rounded,
              color: hasBackup ? AppColors.success : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Last Backup',
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasBackup
                      ? _formatDateTime(_lastBackup!)
                      : 'No backup created in this session',
                  style: TextStyle(
                    color: _secondaryText,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: (hasBackup ? AppColors.success : AppColors.warning)
                  .withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              hasBackup ? 'READY' : 'NOT YET',
              style: TextStyle(
                color: hasBackup ? AppColors.success : AppColors.warning,
                fontSize: 7.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataIncludedCard() {
    const List<(IconData, String)> rows = <(IconData, String)>[
      (Icons.people_alt_rounded, 'Customer profiles'),
      (Icons.straighten_rounded, 'Measurements'),
      (Icons.inventory_2_rounded, 'Orders & payments'),
      (Icons.tune_rounded, 'App preferences'),
    ];

    return _CardShell(
      surface: _surface,
      border: _border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Data Included',
            style: TextStyle(
              color: _primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map(
                ((IconData, String) item) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(item.$1, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      item.$2,
                      style: TextStyle(
                        color: _primaryText,
                        fontSize: 11,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required bool loading,
    required VoidCallback onPressed,
    bool outlined = false,
  }) {
    return _CardShell(
      surface: _surface,
      border: _border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: _primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _secondaryText,
                        fontSize: 9,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: outlined
                ? OutlinedButton.icon(
              onPressed: loading ? null : onPressed,
              icon: loading
                  ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.settings_backup_restore_rounded),
              label: Text(buttonText),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
                : FilledButton.icon(
              onPressed: loading ? null : onPressed,
              icon: loading
                  ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.cloud_upload_rounded),
              label: Text(buttonText),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This screen is ready for UI flow. Connect Create Backup and Restore Backup to your database/storage service when backend backup is implemented.',
              style: TextStyle(
                color: _secondaryText,
                fontSize: 9,
                height: 1.5,
                fontWeight: FontWeight.w600,
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

class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.surface,
    required this.border,
    required this.child,
  });

  final Color surface;
  final Color border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: child,
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
