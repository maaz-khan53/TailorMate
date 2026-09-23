import 'package:flutter/material.dart';

import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/features/orders/presentation/models/order_model.dart';

class UpdateOrderStatusScreen extends StatefulWidget {
  const UpdateOrderStatusScreen({
    super.key,
    required this.currentStatus,
  });

  final OrderStatus currentStatus;

  @override
  State<UpdateOrderStatusScreen> createState() =>
      _UpdateOrderStatusScreenState();
}

class _UpdateOrderStatusScreenState extends State<UpdateOrderStatusScreen> {
  late OrderStatus _selectedStatus;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.inProgress:
        return AppColors.info;
      case OrderStatus.ready:
        return AppColors.success;
      case OrderStatus.delivered:
        return AppColors.primary;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule_rounded;
      case OrderStatus.inProgress:
        return Icons.cut_rounded;
      case OrderStatus.ready:
        return Icons.checkroom_rounded;
      case OrderStatus.delivered:
        return Icons.local_shipping_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  String _description(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order is waiting to be started.';
      case OrderStatus.inProgress:
        return 'Cutting or stitching work is in progress.';
      case OrderStatus.ready:
        return 'Dress is ready for customer pickup.';
      case OrderStatus.delivered:
        return 'Order has been delivered to the customer.';
      case OrderStatus.cancelled:
        return 'Order has been cancelled.';
    }
  }

  Future<void> _saveStatus() async {
    setState(() {
      _saving = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop<OrderStatus>(_selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double contentMaxWidth = screenWidth >= 1100
        ? 760
        : screenWidth >= 700
        ? 700
        : 620;
    final double bodyHorizontalPadding = screenWidth > contentMaxWidth
        ? ((screenWidth - contentMaxWidth) / 2) + 18
        : (screenWidth <= 360 ? 12 : 18);
    final double footerHorizontalPadding = screenWidth > contentMaxWidth
        ? ((screenWidth - contentMaxWidth) / 2) + 16
        : (screenWidth <= 360 ? 12 : 16);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background =
    isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final Color card = isDark ? AppColors.darkCard : AppColors.card;
    final Color primaryText =
    isDark ? AppColors.darkText : AppColors.textPrimary;
    final Color secondaryText =
    isDark ? AppColors.grey400 : AppColors.textSecondary;
    final Color border =
    isDark ? AppColors.darkBorder : AppColors.border;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: primaryText,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
          child: _ScreenBackButton(
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        titleSpacing: 12,
        title: const Text(
          'Update Order Status',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          bodyHorizontalPadding,
          10,
          bodyHorizontalPadding,
          120,
        ),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(23),
            ),
            child: const Row(
              children: <Widget>[
                Icon(
                  Icons.timeline_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Text(
                    'Select the current production stage of this order.',
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...OrderStatus.values.map(
                (OrderStatus status) {
              final bool selected = _selectedStatus == status;
              final Color accent = _statusColor(status);

              return Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Material(
                  color: card,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedStatus = status;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? accent : border,
                          width: selected ? 1.8 : 1,
                        ),
                        boxShadow: selected
                            ? <BoxShadow>[
                          BoxShadow(
                            color: accent.withValues(alpha: 0.12),
                            blurRadius: 15,
                            offset: const Offset(0, 7),
                          ),
                        ]
                            : null,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.11),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              _statusIcon(status),
                              color: accent,
                              size: 23,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  status.label,
                                  style: TextStyle(
                                    color: primaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _description(status),
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 9,
                                    height: 1.35,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: selected ? accent : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? accent : border,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 15,
                            )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            footerHorizontalPadding,
            10,
            footerHorizontalPadding,
            12,
          ),
          decoration: BoxDecoration(
            color: card,
            border: Border(top: BorderSide(color: border)),
          ),
          child: FilledButton.icon(
            onPressed: _saving ? null : _saveStatus,
            icon: _saving
                ? const SizedBox(
              width: 17,
              height: 17,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.save_rounded),
            label: Text(_saving ? 'Updating...' : 'Update Status'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
