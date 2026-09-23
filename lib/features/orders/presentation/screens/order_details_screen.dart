import 'package:flutter/material.dart';

import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/features/orders/presentation/models/order_model.dart';
import 'package:tailorx/features/orders/presentation/screens/receive_payment_screen.dart';
import 'package:tailorx/features/orders/presentation/screens/update_order_status_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  final TailorOrder order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late TailorOrder _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _openStatusScreen() async {
    final OrderStatus? status = await Navigator.of(context).push<OrderStatus>(
      MaterialPageRoute<OrderStatus>(
        builder: (_) => UpdateOrderStatusScreen(
          currentStatus: _order.status,
        ),
      ),
    );

    if (status == null || !mounted) {
      return;
    }

    setState(() {
      _order = _order.copyWith(status: status);
    });
  }

  Future<void> _openPaymentScreen() async {
    final TailorOrder? updatedOrder =
    await Navigator.of(context).push<TailorOrder>(
      MaterialPageRoute<TailorOrder>(
        builder: (_) => ReceivePaymentScreen(order: _order),
      ),
    );

    if (updatedOrder == null || !mounted) {
      return;
    }

    setState(() {
      _order = updatedOrder;
    });
  }

  Future<void> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Order?'),
          content: const Text(
            'This action will permanently remove the order after backend connection.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop<TailorOrder>(_order);
    }
  }

  String _money(double value) => 'Rs ${value.toStringAsFixed(0)}';

  String _date(DateTime date) {
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double contentMaxWidth = screenWidth >= 1200
        ? 980
        : screenWidth >= 700
        ? 840
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Navigator.of(context).pop<TailorOrder>(_order);
        }
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: background,
          foregroundColor: primaryText,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
            child: _ScreenBackButton(
              onTap: () => Navigator.of(context).pop<TailorOrder>(_order),
            ),
          ),
          titleSpacing: 12,
          title: const Text(
            'Order Details',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Delete Order',
              onPressed: _confirmDelete,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            bodyHorizontalPadding,
            8,
            bodyHorizontalPadding,
            120,
          ),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _order.orderCode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${_order.dressName} • ${_order.customerCode}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          _order.status.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _HeroInfo(
                          label: 'Delivery',
                          value: _date(_order.deliveryDate),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 34,
                        color: Colors.white24,
                      ),
                      Expanded(
                        child: _HeroInfo(
                          label: 'Remaining',
                          value: _money(_order.remaining),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Customer',
              icon: Icons.person_rounded,
              card: card,
              border: border,
              primaryText: primaryText,
              child: Column(
                children: <Widget>[
                  _DetailRow(
                    label: 'Name',
                    value: _order.customerName,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                  _DetailRow(
                    label: 'Customer ID',
                    value: _order.customerCode,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                  _DetailRow(
                    label: 'Phone',
                    value: _order.phone,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                  _DetailRow(
                    label: 'Category',
                    value: _order.category,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Order & Delivery',
              icon: Icons.checkroom_rounded,
              card: card,
              border: border,
              primaryText: primaryText,
              child: Column(
                children: <Widget>[
                  _DetailRow(
                    label: 'Dress',
                    value: _order.dressName,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                  _DetailRow(
                    label: 'Order Date',
                    value: _date(_order.createdAt),
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                  _DetailRow(
                    label: 'Delivery Date',
                    value: _date(_order.deliveryDate),
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            if (_order.measurements.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Measurements Used',
                icon: Icons.straighten_rounded,
                card: card,
                border: border,
                primaryText: primaryText,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _order.measurements.entries
                      .map(
                        (MapEntry<String, String> entry) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
            if (_order.designDetails.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Design Details',
                icon: Icons.design_services_rounded,
                card: card,
                border: border,
                primaryText: primaryText,
                child: Column(
                  children: _order.designDetails.entries
                      .map(
                        (MapEntry<String, String> entry) => _DetailRow(
                      label: entry.key,
                      value: entry.value,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      showDivider:
                      entry.key != _order.designDetails.keys.last,
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
            if (_order.tailorNotes.trim().isNotEmpty ||
                _order.orderNotes.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Notes',
                icon: Icons.notes_rounded,
                card: card,
                border: border,
                primaryText: primaryText,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_order.tailorNotes.trim().isNotEmpty)
                      _NoteBlock(
                        title: 'Tailor Notes',
                        text: _order.tailorNotes,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                    if (_order.tailorNotes.trim().isNotEmpty &&
                        _order.orderNotes.trim().isNotEmpty)
                      const SizedBox(height: 12),
                    if (_order.orderNotes.trim().isNotEmpty)
                      _NoteBlock(
                        title: 'Order Notes',
                        text: _order.orderNotes,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Payment',
              icon: Icons.payments_rounded,
              card: card,
              border: border,
              primaryText: primaryText,
              child: Column(
                children: <Widget>[
                  _PaymentSummaryRow(
                    label: 'Total Bill',
                    value: _money(_order.totalBill),
                    color: primaryText,
                    secondaryText: secondaryText,
                  ),
                  _PaymentSummaryRow(
                    label: 'Advance',
                    value: _money(_order.advance),
                    color: AppColors.info,
                    secondaryText: secondaryText,
                  ),
                  _PaymentSummaryRow(
                    label: 'Other Received',
                    value: _money(_order.receivedAfterAdvance),
                    color: AppColors.success,
                    secondaryText: secondaryText,
                  ),
                  _PaymentSummaryRow(
                    label: 'Remaining',
                    value: _money(_order.remaining),
                    color: _order.remaining > 0
                        ? AppColors.error
                        : AppColors.success,
                    secondaryText: secondaryText,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Status Progress',
              icon: Icons.timeline_rounded,
              card: card,
              border: border,
              primaryText: primaryText,
              child: _StatusProgress(
                status: _order.status,
                primaryText: primaryText,
                secondaryText: secondaryText,
                border: border,
                statusColor: _statusColor(_order.status),
              ),
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
            child: Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openStatusScreen,
                    icon: const Icon(Icons.sync_rounded),
                    label: const Text('Update Status'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _order.remaining <= 0
                        ? null
                        : _openPaymentScreen,
                    icon: const Icon(Icons.payments_rounded),
                    label: Text(
                      _order.remaining <= 0
                          ? 'Fully Paid'
                          : 'Receive Payment',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                      AppColors.success.withValues(alpha: 0.55),
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 10,
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
    );
  }
}

class _HeroInfo extends StatelessWidget {
  const _HeroInfo({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.card,
    required this.border,
    required this.primaryText,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color card;
  final Color border;
  final Color primaryText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
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
    this.showDivider = true,
  });

  final String label;
  final String value;
  final Color primaryText;
  final Color secondaryText;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        if (showDivider) ...<Widget>[
          const SizedBox(height: 11),
          Divider(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.border,
          ),
          const SizedBox(height: 11),
        ],
      ],
    );
  }
}

class _NoteBlock extends StatelessWidget {
  const _NoteBlock({
    required this.title,
    required this.text,
    required this.primaryText,
    required this.secondaryText,
  });

  final String title;
  final String text;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: secondaryText,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: primaryText,
              height: 1.45,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummaryRow extends StatelessWidget {
  const _PaymentSummaryRow({
    required this.label,
    required this.value,
    required this.color,
    required this.secondaryText,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final Color color;
  final Color secondaryText;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        if (showDivider) ...<Widget>[
          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.border,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _StatusProgress extends StatelessWidget {
  const _StatusProgress({
    required this.status,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
    required this.statusColor,
  });

  final OrderStatus status;
  final Color primaryText;
  final Color secondaryText;
  final Color border;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: <Widget>[
            Icon(Icons.cancel_rounded, color: AppColors.error),
            SizedBox(width: 9),
            Text(
              'This order is cancelled',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
    }

    const List<OrderStatus> flow = <OrderStatus>[
      OrderStatus.pending,
      OrderStatus.inProgress,
      OrderStatus.ready,
      OrderStatus.delivered,
    ];

    final int currentIndex = flow.indexOf(status);

    return Row(
      children: List<Widget>.generate(flow.length, (int index) {
        final bool active = index <= currentIndex;
        final bool isLast = index == flow.length - 1;

        return Expanded(
          flex: isLast ? 0 : 1,
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: active ? statusColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active ? statusColor : border,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      active ? Icons.check_rounded : Icons.circle_outlined,
                      size: 14,
                      color: active ? Colors.white : secondaryText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 46,
                    child: Text(
                      flow[index].label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: active ? primaryText : secondaryText,
                        fontSize: 7,
                        fontWeight:
                        active ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: index < currentIndex ? statusColor : border,
                  ),
                ),
            ],
          ),
        );
      }),
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
