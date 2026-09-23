import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _items = <_NotificationItem>[
    _NotificationItem(
      title: 'Order ready for delivery',
      message: 'Order TX-1042 for Ali Ahmed is ready for customer pickup.',
      time: '5 min ago',
      icon: Icons.checkroom_rounded,
      type: _NotificationType.success,
      unread: true,
    ),
    _NotificationItem(
      title: 'Delivery due today',
      message: 'Ayesha Noor has an order scheduled for delivery today.',
      time: '28 min ago',
      icon: Icons.local_shipping_outlined,
      type: _NotificationType.warning,
      unread: true,
    ),
    _NotificationItem(
      title: 'Payment received',
      message: 'Rs 2,000 payment was recorded for order TX-1038.',
      time: '2 hours ago',
      icon: Icons.payments_outlined,
      type: _NotificationType.info,
      unread: false,
    ),
    _NotificationItem(
      title: 'New customer added',
      message: 'Hamza Khan was added to your TailorX customer list.',
      time: 'Yesterday',
      icon: Icons.person_add_alt_1_rounded,
      type: _NotificationType.primary,
      unread: false,
    ),
  ];

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

  int get _unreadCount => _items.where((e) => e.unread).length;

  void _markAllRead() {
    setState(() {
      for (final _NotificationItem item in _items) {
        item.unread = false;
      }
    });
  }

  void _toggleRead(_NotificationItem item) {
    setState(() => item.unread = !item.unread);
  }

  Color _accent(_NotificationType type) {
    switch (type) {
      case _NotificationType.success:
        return AppColors.success;
      case _NotificationType.warning:
        return AppColors.warning;
      case _NotificationType.info:
        return AppColors.info;
      case _NotificationType.primary:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool small = width <= 360;
    final bool tablet = width >= 600;
    final double maxWidth = width >= 1100 ? 760 : tablet ? 680 : 460;
    final double horizontal = small ? 12 : width < 600 ? 16 : 24;

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
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        tablet ? 18 : 12,
                        horizontal,
                        12,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildHeader(context, compact: small),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        4,
                        horizontal,
                        12,
                      ),
                      sliver: SliverToBoxAdapter(child: _buildSummary()),
                    ),
                    if (_items.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          0,
                          horizontal,
                          28,
                        ),
                        sliver: SliverList.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildNotificationCard(_items[index]);
                          },
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

  Widget _buildHeader(BuildContext context, {required bool compact}) {
    return Row(
      children: <Widget>[
        _ScreenBackButton(
          compact: compact,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Notifications',
                style: TextStyle(
                  color: _primaryText,
                  fontSize: compact ? 20 : 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Orders, payments and customer updates',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _secondaryText,
                  fontSize: compact ? 9 : 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Notification Center',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _unreadCount == 0
                      ? 'You are all caught up'
                      : '$_unreadCount unread notification${_unreadCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text(
                'Mark all read',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(_NotificationItem item) {
    final Color accent = _accent(item.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleRead(item),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.unread
                ? accent.withValues(alpha: _isDark ? 0.08 : 0.055)
                : _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: item.unread
                  ? accent.withValues(alpha: 0.34)
                  : _border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: accent, size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: _primaryText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (item.unread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.message,
                      style: TextStyle(
                        color: _secondaryText,
                        fontSize: 9.5,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.time,
                      style: TextStyle(
                        color: accent,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: _surfaceSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No Notifications',
              style: TextStyle(
                color: _primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'New order and payment updates will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _secondaryText,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _NotificationType { success, warning, info, primary }

class _NotificationItem {
  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.type,
    required this.unread,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final _NotificationType type;
  bool unread;
}


class _ScreenBackButton extends StatelessWidget {
  const _ScreenBackButton({
    required this.onTap,
    this.compact = false,
  });

  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double size = compact ? 44 : 48;
    final Color surface = isDark ? AppColors.darkSurfaceSoft : Colors.white;
    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.primary.withValues(alpha: 0.18);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.045),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
