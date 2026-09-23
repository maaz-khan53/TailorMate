import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/features/orders/presentation/models/order_model.dart';
import 'package:tailorx/features/orders/presentation/screens/order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    this.initialOrders,
  });

  final List<TailorOrder>? initialOrders;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late List<TailorOrder> _orders;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();

  OrderStatus? _selectedStatus;
  String _query = '';

  @override
  void initState() {
    super.initState();

    _orders = List<TailorOrder>.from(
      widget.initialOrders ?? TailorOrder.demoOrders(),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<TailorOrder> get _filteredOrders {
    final String normalizedQuery = _query.trim().toLowerCase();

    final List<TailorOrder> result = _orders.where((TailorOrder order) {
      final bool matchesStatus =
          _selectedStatus == null || order.status == _selectedStatus;

      final bool matchesSearch = normalizedQuery.isEmpty ||
          order.customerName.toLowerCase().contains(normalizedQuery) ||
          order.customerCode.toLowerCase().contains(normalizedQuery) ||
          order.phone.toLowerCase().contains(normalizedQuery) ||
          order.orderCode.toLowerCase().contains(normalizedQuery) ||
          order.dressName.toLowerCase().contains(normalizedQuery);

      return matchesStatus && matchesSearch;
    }).toList();

    result.sort(
          (TailorOrder first, TailorOrder second) =>
          first.deliveryDate.compareTo(second.deliveryDate),
    );

    return result;
  }


  Future<void> _openOrder(TailorOrder order) async {
    final TailorOrder? updatedOrder = await Navigator.of(context).push<TailorOrder>(
      MaterialPageRoute<TailorOrder>(
        builder: (_) => OrderDetailsScreen(order: order),
      ),
    );

    if (updatedOrder == null || !mounted) {
      return;
    }

    setState(() {
      final int index = _orders.indexWhere(
            (TailorOrder item) => item.id == updatedOrder.id,
      );

      if (index != -1) {
        _orders[index] = updatedOrder;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double contentMaxWidth = screenWidth >= 1200
        ? 1080
        : screenWidth >= 700
        ? 920
        : 620;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background =
    isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final Color cardColor = isDark ? AppColors.darkCard : AppColors.card;
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Orders',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              'Manage stitching, delivery and payments',
              style: TextStyle(
                fontSize: 11,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: _ResponsiveContent(
        maxWidth: contentMaxWidth,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  sliver: SliverToBoxAdapter(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (String value) {
                        setState(() {
                          _query = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search name, ID, phone or order...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _query = '';
                            });
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                        filled: true,
                        fillColor: cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 64,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      children: <Widget>[
                        _FilterChip(
                          label: 'All',
                          selected: _selectedStatus == null,
                          onTap: () {
                            setState(() {
                              _selectedStatus = null;
                            });
                          },
                        ),
                        ...OrderStatus.values.map(
                              (OrderStatus status) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _FilterChip(
                              label: status.label,
                              selected: _selectedStatus == status,
                              onTap: () {
                                setState(() {
                                  _selectedStatus = status;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${_filteredOrders.length} Orders',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          'Nearest delivery first',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_filteredOrders.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyOrders(
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
                    sliver: SliverList.separated(
                      itemCount: _filteredOrders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final TailorOrder order = _filteredOrders[index];

                        return _OrderCard(
                          order: order,
                          cardColor: cardColor,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          border: border,
                          onTap: () => _openOrder(order),
                        );
                      },
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onTap(),
      label: Text(label),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkCard
          : AppColors.card,
      side: BorderSide(
        color: selected
            ? AppColors.primary
            : Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBorder
            : AppColors.border,
      ),
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkText
            : AppColors.textPrimary,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.cardColor,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
    required this.onTap,
  });

  final TailorOrder order;
  final Color cardColor;
  final Color primaryText;
  final Color secondaryText;
  final Color border;
  final VoidCallback onTap;

  Color get _statusColor {
    switch (order.status) {
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

  String _money(double amount) {
    return 'Rs ${amount.toStringAsFixed(0)}';
  }

  String _date(DateTime date) {
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String initial = order.customerName.trim().isEmpty
        ? '?'
        : order.customerName.trim()[0].toUpperCase();

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.16
                      : 0.045,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: _CustomerPhoto(
                        path: order.customerPhotoPath,
                        initial: initial,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          order.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${order.customerCode}  •  ${order.orderCode}',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      order.status.label,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurfaceSoft
                      : AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _MiniInfo(
                        icon: Icons.checkroom_rounded,
                        label: 'Dress',
                        value: order.dressName,
                        color: primaryText,
                        muted: secondaryText,
                      ),
                    ),
                    Container(width: 1, height: 33, color: border),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MiniInfo(
                        icon: Icons.event_rounded,
                        label: 'Delivery',
                        value: _date(order.deliveryDate),
                        color: primaryText,
                        muted: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _PaymentText(
                      label: 'Total',
                      value: _money(order.totalBill),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                  ),
                  Expanded(
                    child: _PaymentText(
                      label: 'Received',
                      value: _money(order.totalReceived),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                  ),
                  Expanded(
                    child: _PaymentText(
                      label: 'Remaining',
                      value: _money(order.remaining),
                      primaryText: order.remaining > 0
                          ? AppColors.error
                          : AppColors.success,
                      secondaryText: secondaryText,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: secondaryText,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerPhoto extends StatelessWidget {
  const _CustomerPhoto({
    required this.path,
    required this.initial,
  });

  final String? path;
  final String initial;

  @override
  Widget build(BuildContext context) {
    final String? cleanPath = path?.trim();

    if (cleanPath == null || cleanPath.isEmpty) {
      return _FallbackAvatar(initial: initial);
    }

    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      return Image.network(
        cleanPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _FallbackAvatar(initial: initial),
      );
    }

    return Image.file(
      File(cleanPath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _FallbackAvatar(initial: initial),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.muted,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.primary, size: 17),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  color: muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentText extends StatelessWidget {
  const _PaymentText({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: secondaryText,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: primaryText,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({
    required this.primaryText,
    required this.secondaryText,
  });

  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Orders Found',
              style: TextStyle(
                color: primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try another search or status filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent({
    required this.maxWidth,
    required this.child,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          child: child,
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
